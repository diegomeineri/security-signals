# prex-security-signals

Security signals

## Install

```bash
npm install prex-security-signals
npx cap sync
```

## API

<docgen-index>

* [`getScreenCaptureState()`](#getscreencapturestate)
* [`startScreenCaptureWatcher()`](#startscreencapturewatcher)
* [`stopScreenCaptureWatcher()`](#stopscreencapturewatcher)
* [`getCommunicationState()`](#getcommunicationstate)
* [`startCommunicationWatcher(...)`](#startcommunicationwatcher)
* [`stopCommunicationWatcher()`](#stopcommunicationwatcher)
* [`addListener('screenCaptureChanged', ...)`](#addlistenerscreencapturechanged-)
* [`addListener('communicationChanged', ...)`](#addlistenercommunicationchanged-)
* [`removeAllListeners()`](#removealllisteners)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getScreenCaptureState()

```typescript
getScreenCaptureState() => Promise<ScreenCaptureState>
```

**Returns:** <code>Promise&lt;<a href="#screencapturestate">ScreenCaptureState</a>&gt;</code>

--------------------


### startScreenCaptureWatcher()

```typescript
startScreenCaptureWatcher() => Promise<{ supported: boolean; }>
```

**Returns:** <code>Promise&lt;{ supported: boolean; }&gt;</code>

--------------------


### stopScreenCaptureWatcher()

```typescript
stopScreenCaptureWatcher() => Promise<void>
```

--------------------


### getCommunicationState()

```typescript
getCommunicationState() => Promise<CommunicationState>
```

**Returns:** <code>Promise&lt;<a href="#communicationstate">CommunicationState</a>&gt;</code>

--------------------


### startCommunicationWatcher(...)

```typescript
startCommunicationWatcher(options?: { pollMs?: number | undefined; } | undefined) => Promise<{ supported: boolean; }>
```

| Param         | Type                              |
| ------------- | --------------------------------- |
| **`options`** | <code>{ pollMs?: number; }</code> |

**Returns:** <code>Promise&lt;{ supported: boolean; }&gt;</code>

--------------------


### stopCommunicationWatcher()

```typescript
stopCommunicationWatcher() => Promise<void>
```

--------------------


### addListener('screenCaptureChanged', ...)

```typescript
addListener(eventName: 'screenCaptureChanged', listenerFunc: (state: { captured: boolean; }) => void) => Promise<PluginListenerHandle>
```

| Param              | Type                                                    |
| ------------------ | ------------------------------------------------------- |
| **`eventName`**    | <code>'screenCaptureChanged'</code>                     |
| **`listenerFunc`** | <code>(state: { captured: boolean; }) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

--------------------


### addListener('communicationChanged', ...)

```typescript
addListener(eventName: 'communicationChanged', listenerFunc: (state: CommunicationState) => void) => Promise<PluginListenerHandle>
```

| Param              | Type                                                                                  |
| ------------------ | ------------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'communicationChanged'</code>                                                   |
| **`listenerFunc`** | <code>(state: <a href="#communicationstate">CommunicationState</a>) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => Promise<void>
```

--------------------


### Interfaces


#### ScreenCaptureState

| Prop            | Type                         |
| --------------- | ---------------------------- |
| **`supported`** | <code>boolean</code>         |
| **`captured`**  | <code>boolean \| null</code> |


#### CommunicationState

| Prop                    | Type                                                                              |
| ----------------------- | --------------------------------------------------------------------------------- |
| **`micInUseSupported`** | <code>boolean</code>                                                              |
| **`micInUse`**          | <code>boolean \| null</code>                                                      |
| **`activeRecordings`**  | <code>number</code>                                                               |
| **`callSupported`**     | <code>boolean</code>                                                              |
| **`callActive`**        | <code>boolean \| null</code>                                                      |
| **`audioMode`**         | <code>'normal' \| 'inCall' \| 'inCommunication' \| 'ringtone' \| 'unknown'</code> |
| **`speakerphoneOn`**    | <code>boolean</code>                                                              |
| **`bluetoothScoOn`**    | <code>boolean</code>                                                              |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>
