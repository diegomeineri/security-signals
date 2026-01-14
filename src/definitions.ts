import { PluginListenerHandle } from "@capacitor/core";

export interface ScreenCaptureState {
  supported: boolean;
  captured: boolean | null; // null si no se puede saber
}

export interface CommunicationState {
  micInUseSupported: boolean;
  micInUse: boolean | null;
  activeRecordings?: number;

  callSupported: boolean;
  callActive: boolean | null;

  // Android extra (heurística)
  audioMode?: 'normal' | 'inCall' | 'inCommunication' | 'ringtone' | 'unknown';
  speakerphoneOn?: boolean;
  bluetoothScoOn?: boolean;
}

export interface SecuritySignalsPlugin {
  // iOS: real. Android: unsupported (captured=null)
  getScreenCaptureState(): Promise<ScreenCaptureState>;
  startScreenCaptureWatcher(): Promise<{ supported: boolean }>;
  stopScreenCaptureWatcher(): Promise<void>;
  // event: "screenCaptureChanged" { captured: boolean }

  // Android: real (heurístico). iOS: call opcional (CallKit), micInUse no.
  getCommunicationState(): Promise<CommunicationState>;
  startCommunicationWatcher(options?: { pollMs?: number }): Promise<{ supported: boolean }>;
  stopCommunicationWatcher(): Promise<void>;
  // event: "communicationChanged" CommunicationState

  addListener(
    eventName: 'screenCaptureChanged',
    listenerFunc: (state: { captured: boolean }) => void
  ): Promise<PluginListenerHandle>;

  addListener(
    eventName: 'communicationChanged',
    listenerFunc: (state: CommunicationState) => void
  ): Promise<PluginListenerHandle>;

  removeAllListeners(): Promise<void>;
}
