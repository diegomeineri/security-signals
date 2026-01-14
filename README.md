# Security Signals

<p align="center">
  <img src="https://img.shields.io/badge/Capacitor-7.0.0+-blue.svg" alt="Capacitor">
  <img src="https://img.shields.io/badge/iOS-14.0+-green.svg" alt="iOS">
  <img src="https://img.shields.io/badge/Android-API%2021+-green.svg" alt="Android">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License">
</p>

Un plugin de Capacitor para detectar señales de seguridad en dispositivos móviles, incluyendo captura de pantalla, llamadas activas y uso del micrófono.

## 📋 Características

- ✅ **Detección de captura de pantalla** (iOS)
- ✅ **Detección de llamadas activas** (iOS con CallKit, Android heurístico)
- ✅ **Detección de uso de micrófono** (Android)
- ✅ **Detección de grabación de pantalla** (iOS)
- ✅ **Listeners en tiempo real** para cambios de estado
- ✅ **Soporte para iOS 14+ y Android API 21+**

## 🎯 Casos de uso

Este plugin es ideal para aplicaciones que requieren:

- **Seguridad bancaria/financiera**: Prevenir capturas de pantalla de información sensible
- **Aplicaciones de pagos**: Detectar si hay grabaciones activas durante transacciones
- **Apps corporativas**: Monitorear el uso de comunicaciones durante sesiones críticas
- **Prevención de fraude**: Detectar comportamientos sospechosos del dispositivo

## 📦 Instalación

```bash
npm install github:diegomeineri/security-signals
npx cap sync
```

O con una versión específica:

```bash
npm install github:diegomeineri/security-signals#v1.0.0
npx cap sync
```

## 🚀 Uso básico

### Importar el plugin

```typescript
import { securitySignals } from 'security-signals';
```

### Detección de captura de pantalla (iOS)

```typescript
// Obtener estado actual
const screenState = await securitySignals.getScreenCaptureState();
console.log('Captura soportada:', screenState.supported);
console.log('Pantalla capturada:', screenState.captured);

// Iniciar monitoreo en tiempo real
await securitySignals.startScreenCaptureWatcher();

// Escuchar cambios
securitySignals.addListener('screenCaptureChanged', (state) => {
  if (state.captured) {
    console.log('⚠️ Usuario está grabando o capturando la pantalla');
    // Ocultar información sensible, cerrar sesión, etc.
  } else {
    console.log('✅ Captura de pantalla detenida');
  }
});

// Detener monitoreo cuando no sea necesario
await securitySignals.stopScreenCaptureWatcher();
```

### Detección de comunicaciones (Llamadas/Micrófono)

```typescript
// Obtener estado actual
const commState = await securitySignals.getCommunicationState();
console.log('Llamada activa:', commState.callActive);
console.log('Micrófono en uso:', commState.micInUse);
console.log('Grabaciones activas:', commState.activeRecordings);

// Android: Info adicional sobre audio
console.log('Modo de audio:', commState.audioMode); // 'normal', 'inCall', 'inCommunication'
console.log('Altavoz activado:', commState.speakerphoneOn);
console.log('Bluetooth SCO:', commState.bluetoothScoOn);

// Iniciar monitoreo (opcional: configurar intervalo de polling)
await securitySignals.startCommunicationWatcher({ pollMs: 1000 });

// Escuchar cambios
securitySignals.addListener('communicationChanged', (state) => {
  if (state.callActive) {
    console.log('⚠️ Llamada activa detectada');
  }
  if (state.micInUse) {
    console.log('⚠️ Micrófono en uso');
  }
});

// Detener monitoreo
await securitySignals.stopCommunicationWatcher();
```

## 💡 Ejemplo completo: Protección de pantalla sensible

```typescript
import { Component, OnDestroy, OnInit } from '@angular/core';
import { securitySignals } from 'security-signals';
import { PluginListenerHandle } from '@capacitor/core';

@Component({
  selector: 'app-payment',
  templateUrl: './payment.page.html'
})
export class PaymentPage implements OnInit, OnDestroy {
  private screenCaptureListener?: PluginListenerHandle;
  private communicationListener?: PluginListenerHandle;

  showSensitiveInfo = true;

  async ngOnInit() {
    // Iniciar monitoreo de captura de pantalla
    const screenResult = await securitySignals.startScreenCaptureWatcher();

    if (screenResult.supported) {
      this.screenCaptureListener = await securitySignals.addListener(
        'screenCaptureChanged',
        (state) => {
          if (state.captured) {
            // Ocultar información sensible
            this.showSensitiveInfo = false;
            this.showWarning('Captura de pantalla detectada');
          }
        }
      );
    }

    // Iniciar monitoreo de comunicaciones
    const commResult = await securitySignals.startCommunicationWatcher({ pollMs: 2000 });

    if (commResult.supported) {
      this.communicationListener = await securitySignals.addListener(
        'communicationChanged',
        (state) => {
          if (state.callActive || state.micInUse) {
            // Pausar operación sensible
            this.pauseSensitiveOperation();
          }
        }
      );
    }
  }

  async ngOnDestroy() {
    // Limpiar listeners
    await this.screenCaptureListener?.remove();
    await this.communicationListener?.remove();

    // Detener watchers
    await securitySignals.stopScreenCaptureWatcher();
    await securitySignals.stopCommunicationWatcher();

    // Remover todos los listeners
    await securitySignals.removeAllListeners();
  }

  private showWarning(message: string) {
    // Mostrar alerta al usuario
    console.warn(message);
  }

  private pauseSensitiveOperation() {
    // Pausar transacción o proceso sensible
    console.log('Operación pausada por seguridad');
  }
}
```

## 🔧 API Reference

### Métodos

#### `getScreenCaptureState()`

Obtiene el estado actual de captura de pantalla.

```typescript
getScreenCaptureState() => Promise<ScreenCaptureState>
```

**Returns:** `Promise<ScreenCaptureState>`

**Soporte:**
- ✅ iOS: Completamente funcional
- ❌ Android: No soportado (`captured` será `null`)

---

#### `startScreenCaptureWatcher()`

Inicia el monitoreo en tiempo real de capturas de pantalla.

```typescript
startScreenCaptureWatcher() => Promise<{ supported: boolean }>
```

**Returns:** `Promise<{ supported: boolean }>`

**Nota:** Dispara eventos `screenCaptureChanged` cuando cambia el estado.

---

#### `stopScreenCaptureWatcher()`

Detiene el monitoreo de captura de pantalla.

```typescript
stopScreenCaptureWatcher() => Promise<void>
```

---

#### `getCommunicationState()`

Obtiene el estado actual de comunicaciones (llamadas, micrófono).

```typescript
getCommunicationState() => Promise<CommunicationState>
```

**Returns:** `Promise<CommunicationState>`

**Soporte:**
- ✅ Android: Completamente funcional (heurístico)
- ⚠️ iOS: Llamadas con CallKit opcional, micrófono no soportado

---

#### `startCommunicationWatcher(options?)`

Inicia el monitoreo en tiempo real de comunicaciones.

```typescript
startCommunicationWatcher(options?: { pollMs?: number }) => Promise<{ supported: boolean }>
```

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `options.pollMs` | `number` | `1000` | Intervalo de polling en milisegundos |

**Returns:** `Promise<{ supported: boolean }>`

---

#### `stopCommunicationWatcher()`

Detiene el monitoreo de comunicaciones.

```typescript
stopCommunicationWatcher() => Promise<void>
```

---

#### `addListener(eventName, listenerFunc)`

Registra un listener para eventos del plugin.

```typescript
// Para captura de pantalla
addListener(
  eventName: 'screenCaptureChanged',
  listenerFunc: (state: { captured: boolean }) => void
) => Promise<PluginListenerHandle>

// Para comunicaciones
addListener(
  eventName: 'communicationChanged',
  listenerFunc: (state: CommunicationState) => void
) => Promise<PluginListenerHandle>
```

**Returns:** `Promise<PluginListenerHandle>`

---

#### `removeAllListeners()`

Remueve todos los listeners registrados.

```typescript
removeAllListeners() => Promise<void>
```

---

### Interfaces

#### `ScreenCaptureState`

```typescript
interface ScreenCaptureState {
  supported: boolean;      // Si el dispositivo soporta detección
  captured: boolean | null; // true = capturando, false = no, null = no soportado
}
```

#### `CommunicationState`

```typescript
interface CommunicationState {
  // Micrófono
  micInUseSupported: boolean;
  micInUse: boolean | null;
  activeRecordings?: number;  // Número de grabaciones activas (Android)

  // Llamadas
  callSupported: boolean;
  callActive: boolean | null;

  // Android: Información adicional heurística
  audioMode?: 'normal' | 'inCall' | 'inCommunication' | 'ringtone' | 'unknown';
  speakerphoneOn?: boolean;
  bluetoothScoOn?: boolean;
}
```

## 📱 Compatibilidad por plataforma

| Característica | iOS | Android |
|----------------|-----|---------|
| Captura de pantalla | ✅ Full | ❌ No |
| Grabación de pantalla | ✅ Full | ❌ No |
| Detección de llamadas | ⚠️ CallKit | ✅ Heurístico |
| Micrófono en uso | ❌ No | ✅ Full |
| Audio mode | ❌ No | ✅ Full |
| Listeners en tiempo real | ✅ Nativo | ✅ Polling |

## ⚠️ Consideraciones importantes

### iOS
- La detección de captura de pantalla funciona de forma nativa mediante `UIScreen.capturedDidChangeNotification`
- Requiere iOS 14.0 o superior
- La detección de llamadas requiere CallKit configurado en la app

### Android
- La detección de comunicaciones es **heurística** basada en:
  - Estado del `AudioManager`
  - Modo de audio activo
  - Estado del Bluetooth SCO
  - Permisos de grabación de audio
- Requiere permisos de `RECORD_AUDIO` para detección de micrófono
- No puede detectar capturas de pantalla de forma nativa

## 🔐 Permisos requeridos

### Android (`AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.BLUETOOTH" />
```

### iOS (`Info.plist`)

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Necesitamos acceso al micrófono para detectar llamadas activas</string>
```

## 🛠️ Desarrollo

```bash
# Instalar dependencias
npm install

# Compilar el plugin
npm run build

# Verificar iOS
npm run verify:ios

# Verificar Android
npm run verify:android

# Generar documentación
npm run docgen
```

## 📄 Licencia

MIT

## 👥 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 🐛 Reportar problemas

Si encuentras algún bug o tienes una sugerencia, por favor abre un issue en GitHub:

https://github.com/diegomeineri/security-signals/issues

---

**Nota:** Este plugin fue desarrollado para mejorar la seguridad en aplicaciones móviles. Úsalo responsablemente y respetando la privacidad de los usuarios.

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>
