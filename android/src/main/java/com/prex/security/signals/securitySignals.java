package com.prex.security.signals;

import com.getcapacitor.Logger;

public class securitySignals {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
