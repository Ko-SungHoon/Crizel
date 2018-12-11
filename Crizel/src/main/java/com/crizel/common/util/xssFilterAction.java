package com.crizel.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class xssFilterAction extends HttpServletRequestWrapper {
	public xssFilterAction(HttpServletRequest servletRequest) {
		super(servletRequest);
	}

	public String[] getParameterValues(String parameter) {

		String[] values = super.getParameterValues(parameter);
		if (values == null) {
			return null;
		}
		int count = values.length;
		String[] encodedValues = new String[count];
		for (int i = 0; i < count; i++) {
			encodedValues[i] = cleanXSS(values[i]);
		}
		return encodedValues;
	}

	public String getParameter(String parameter) {
		String value = super.getParameter(parameter);
		if (value == null) {
			return null;
		}
		return cleanXSS(value);
	}

	public String getHeader(String name) {
		String value = super.getHeader(name);
		if (value == null)
			return null;
		return cleanXSS(value);

	}

	private String cleanXSS(String value) {
		// You'll need to remove the spaces from the html entities below
		value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					 .replaceAll("onerror", "x-onerror").replaceAll("window.open", "x-window.open")
					 .replaceAll("document", "x-document").replaceAll("vbscript", "x-vbscript")
					 .replaceAll("applet", "x-applet").replaceAll("embed", "x-embed")
					 .replaceAll("grameset", "x-grameset").replaceAll("layer", "x-layer")
					 .replaceAll("bgsound", "x-bgsound").replaceAll("alert", "x-alert")
					 .replaceAll("onblur", "x-onblur").replaceAll("javascript", "x-javascript")
					 .replaceAll("onchange", "x-onchange").replaceAll("onclick", "x-onclick")
					 .replaceAll("ondblclick", "x-ondblclick").replaceAll("onfocus", "x-onfocus")
					 .replaceAll("onload", "x-onload").replaceAll("onmouse", "x-onmouse")
					 .replaceAll("onscroll", "x-onscroll").replaceAll("onsubmit", "x-onsubmit")
					 .replaceAll("onunload", "x-onunload").replaceAll("script", "x-script")
					 .replaceAll("object", "x-object").replaceAll("iframe", "x-iframe");
		return value;
	}
}
