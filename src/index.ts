import { registerPlugin } from '@capacitor/core';

import type { SecuritySignalsPlugin } from './definitions';

const securitySignals = registerPlugin<SecuritySignalsPlugin>('securitySignals');

export * from './definitions';
export { securitySignals };
