import { PluginListenerHandle } from "@capacitor/core";
export interface ScreenCaptureState {
    supported: boolean;
    captured: boolean | null;
}
export interface CommunicationState {
    micInUseSupported: boolean;
    micInUse: boolean | null;
    activeRecordings?: number;
    callSupported: boolean;
    callActive: boolean | null;
    audioMode?: 'normal' | 'inCall' | 'inCommunication' | 'ringtone' | 'unknown';
    speakerphoneOn?: boolean;
    bluetoothScoOn?: boolean;
}
export interface SecuritySignalsPlugin {
    getScreenCaptureState(): Promise<ScreenCaptureState>;
    startScreenCaptureWatcher(): Promise<{
        supported: boolean;
    }>;
    stopScreenCaptureWatcher(): Promise<void>;
    getCommunicationState(): Promise<CommunicationState>;
    startCommunicationWatcher(options?: {
        pollMs?: number;
    }): Promise<{
        supported: boolean;
    }>;
    stopCommunicationWatcher(): Promise<void>;
    addListener(eventName: 'screenCaptureChanged', listenerFunc: (state: {
        captured: boolean;
    }) => void): Promise<PluginListenerHandle>;
    addListener(eventName: 'communicationChanged', listenerFunc: (state: CommunicationState) => void): Promise<PluginListenerHandle>;
    removeAllListeners(): Promise<void>;
}
