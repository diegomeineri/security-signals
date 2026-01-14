package com.prex.security.signals;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "securitySignals")
public class securitySignalsPlugin extends Plugin {

 class SecuritySignalsPlugin : Plugin() {

        private val mainHandler = Handler(Looper.getMainLooper())
        private var pollRunnable: Runnable? = null

        @PluginMethod
        fun getScreenCaptureState(call: PluginCall) {
            // Android: no hay API pública confiable para "screen recording activo"
            call.resolve(JSObject().apply {
                put("supported", false)
                put("captured", JSValue.NULL)
            })
        }

        @PluginMethod
        fun startScreenCaptureWatcher(call: PluginCall) {
            call.resolve(JSObject().apply { put("supported", false) })
        }

        @PluginMethod
        fun stopScreenCaptureWatcher(call: PluginCall) {
            call.resolve()
        }

        // ---- Communication ----

        private fun buildCommState(): JSObject {
            val am = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

            val mode = am.mode
            val audioMode = when (mode) {
                AudioManager.MODE_IN_CALL -> "inCall"
                AudioManager.MODE_IN_COMMUNICATION -> "inCommunication"
                AudioManager.MODE_RINGTONE -> "ringtone"
                AudioManager.MODE_NORMAL -> "normal"
                else -> "unknown"
            }

            val likelyInCall = (mode == AudioManager.MODE_IN_CALL || mode == AudioManager.MODE_IN_COMMUNICATION)

            val (micSupported, micInUse, count) =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { // API 24+
                    val list = am.activeRecordingConfigurations
                    Triple(true, list.isNotEmpty(), list.size)
                } else {
                    Triple(false, null, null)
                }

            return JSObject().apply {
                put("micInUseSupported", micSupported)
                put("micInUse", micInUse ?: JSValue.NULL)
                if (count != null) put("activeRecordings", count)

                put("callSupported", true)
                put("callActive", likelyInCall)

                put("audioMode", audioMode)
                put("speakerphoneOn", am.isSpeakerphoneOn)
                put("bluetoothScoOn", am.isBluetoothScoOn)
            }
        }

        @PluginMethod
        fun getCommunicationState(call: PluginCall) {
            call.resolve(buildCommState())
        }

        @PluginMethod
        fun startCommunicationWatcher(call: PluginCall) {
            val pollMs = call.getInt("pollMs") ?: 500

            pollRunnable?.let { mainHandler.removeCallbacks(it) }
            pollRunnable = object : Runnable {
                override fun run() {
                    notifyListeners("communicationChanged", buildCommState())
                    mainHandler.postDelayed(this, pollMs.toLong())
                }
            }

            mainHandler.post(pollRunnable!!)
            call.resolve(JSObject().apply { put("supported", true) })
        }

        @PluginMethod
        fun stopCommunicationWatcher(call: PluginCall) {
            pollRunnable?.let { mainHandler.removeCallbacks(it) }
            pollRunnable = null
            call.resolve()
        }
    }
}
