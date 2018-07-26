/**
 * HTTP client-side implementation that uses forge.net sockets.
 *
 * @author Dave Longley
 *
 * Copyright (c) 2010-2014 Digital Bazaar, Inc. All rights reserved.
 */
!function(){var e={};forge.debug&&forge.debug.set("forge.http","clients",[]);var t=function(e){return e.toLowerCase().replace(/(^.)|(-.)/g,function(e){return e.toUpperCase()})},o=function(e){return"forge.http."+e.url.scheme+"."+e.url.host+"."+e.url.port},n=function(e){if(e.persistCookies)try{var t=forge.util.getItem(e.socketPool.flashApi,o(e),"cookies");e.cookies=t||{}}catch(n){}},r=function(e){if(e.persistCookies)try{forge.util.setItem(e.socketPool.flashApi,o(e),"cookies",e.cookies)}catch(t){}n(e)},i=function(e){if(e.persistCookies)try{forge.util.clearItems(e.socketPool.flashApi,o(e))}catch(t){}},l=function(e,t){t.isConnected()?(t.options.request.connectTime=+new Date,t.connected({type:"connect",id:t.id})):(t.options.request.connectTime=+new Date,t.connect({host:e.url.host,port:e.url.port,policyPort:e.policyPort,policyUrl:e.policyUrl}))},s=function(e,t){t.buffer.clear();for(var o=null;null===o&&e.requests.length>0;)o=e.requests.shift(),o.request.aborted&&(o=null);null===o?(null!==t.options&&(t.options=null),e.idle.push(t)):(t.retries=1,t.options=o,l(e,t))},a=function(e,t,o){t.options=null,t.connected=function(o){if(null===t.options)s(e,t);else{var n=t.options.request;if(n.connectTime=+new Date-n.connectTime,o.socket=t,t.options.connected(o),n.aborted)t.close();else{var r=n.toString();n.body&&(r+=n.body),n.time=+new Date,t.send(r),n.time=+new Date-n.time,t.options.response.time=+new Date,t.sending=!0}}},t.closed=function(o){if(t.sending)t.sending=!1,t.retries>0?(--t.retries,l(e,t)):t.error({id:t.id,type:"ioError",message:"Connection closed during send. Broken pipe.",bytesAvailable:0});else{var n=t.options.response;n.readBodyUntilClose&&(n.time=+new Date-n.time,n.bodyReceived=!0,t.options.bodyReady({request:t.options.request,response:n,socket:t})),t.options.closed(o),s(e,t)}},t.data=function(o){t.sending=!1;var n=t.options.request;if(n.aborted)t.close();else{var r=t.options.response,i=t.receive(o.bytesAvailable);if(null!==i&&(t.buffer.putBytes(i),r.headerReceived||(r.readHeader(t.buffer),r.headerReceived&&t.options.headerReady({request:t.options.request,response:r,socket:t})),r.headerReceived&&!r.bodyReceived&&r.readBody(t.buffer),r.bodyReceived)){t.options.bodyReady({request:t.options.request,response:r,socket:t});var l=r.getField("Connection")||"";-1!=l.indexOf("close")||"HTTP/1.0"===r.version&&null===r.getField("Keep-Alive")?t.close():s(e,t)}}},t.error=function(e){t.options.error({type:e.type,message:e.message,request:t.options.request,response:t.options.response,socket:t}),t.close()},o?(t=forge.tls.wrapSocket({sessionId:null,sessionCache:{},caStore:o.caStore,cipherSuites:o.cipherSuites,socket:t,virtualHost:o.virtualHost,verify:o.verify,getCertificate:o.getCertificate,getPrivateKey:o.getPrivateKey,getSignature:o.getSignature,deflate:o.deflate||null,inflate:o.inflate||null}),t.options=null,t.buffer=forge.util.createBuffer(),e.sockets.push(t),o.prime?t.connect({host:e.url.host,port:e.url.port,policyPort:e.policyPort,policyUrl:e.policyUrl}):e.idle.push(t)):(t.buffer=forge.util.createBuffer(),e.sockets.push(t),e.idle.push(t))},c=function(e){var t=!1;if(-1!==e.maxAge){var o=g(new Date),n=e.created+e.maxAge;o>=n&&(t=!0)}return t},u=function(e,t){var o=[],n=(e.url,e.cookies);for(var r in n){var i=n[r];for(var l in i){var s=i[l];c(s)?o.push(s):0===t.path.indexOf(s.path)&&t.addCookie(s)}}for(var a=0;a<o.length;++a){var s=o[a];e.removeCookie(s.name,s.path)}},d=function(e,t){for(var o=t.getCookies(),n=0;n<o.length;++n)try{e.setCookie(o[n])}catch(r){}};e.createClient=function(t){var o=null;t.caCerts&&(o=forge.pki.createCaStore(t.caCerts)),t.url=t.url||window.location.protocol+"//"+window.location.host;var s=e.parseUrl(t.url);if(!s){var c=new Error("Invalid url.");throw c.details={url:t.url},c}t.connections=t.connections||1;var f=t.socketPool,p={url:s,socketPool:f,policyPort:t.policyPort,policyUrl:t.policyUrl,requests:[],sockets:[],idle:[],secure:"https"===s.scheme,cookies:{},persistCookies:"undefined"==typeof t.persistCookies?!0:t.persistCookies};forge.debug&&forge.debug.get("forge.http","clients").push(p),n(p);var h=function(e,t,o,n){if(0===o&&t===!0){var r=n[o].subject.getField("CN");(null===r||p.url.host!==r.value)&&(t={message:"Certificate common name does not match url host."})}return t},v=null;p.secure&&(v={caStore:o,cipherSuites:t.cipherSuites||null,virtualHost:t.virtualHost||s.host,verify:t.verify||h,getCertificate:t.getCertificate||null,getPrivateKey:t.getPrivateKey||null,getSignature:t.getSignature||null,prime:t.primeTlsSockets||!1},null!==f.flashApi&&(v.deflate=function(e){return forge.util.deflate(f.flashApi,e,!0)},v.inflate=function(e){return forge.util.inflate(f.flashApi,e,!0)}));for(var y=0;y<t.connections;++y)a(p,f.createSocket(),v);return p.send=function(t){null===t.request.getField("Host")&&t.request.setField("Host",p.url.fullHost);var o={};if(o.request=t.request,o.connected=t.connected||function(){},o.closed=t.close||function(){},o.headerReady=function(e){d(p,e.response),t.headerReady&&t.headerReady(e)},o.bodyReady=t.bodyReady||function(){},o.error=t.error||function(){},o.response=e.createResponse(),o.response.time=0,o.response.flashApi=p.socketPool.flashApi,o.request.flashApi=p.socketPool.flashApi,o.request.abort=function(){o.request.aborted=!0,o.connected=function(){},o.closed=function(){},o.headerReady=function(){},o.bodyReady=function(){},o.error=function(){}},u(p,o.request),0===p.idle.length)p.requests.push(o);else{for(var n=null,r=p.idle.length,i=0;null===n&&r>i;++i)n=p.idle[i],n.isConnected()?p.idle.splice(i,1):n=null;null===n&&(n=p.idle.pop()),n.options=o,l(p,n)}},p.destroy=function(){p.requests=[];for(var e=0;e<p.sockets.length;++e)p.sockets[e].close(),p.sockets[e].destroy();p.socketPool=null,p.sockets=[],p.idle=[]},p.setCookie=function(t){var o;if("undefined"!=typeof t.name)if(null===t.value||"undefined"==typeof t.value||""===t.value)o=p.removeCookie(t.name,t.path);else{if(t.comment=t.comment||"",t.maxAge=t.maxAge||0,t.secure="undefined"==typeof t.secure?!0:t.secure,t.httpOnly=t.httpOnly||!0,t.path=t.path||"/",t.domain=t.domain||null,t.version=t.version||null,t.created=g(new Date),t.secure!==p.secure){var n=new Error("Http client url scheme is incompatible with cookie secure flag.");throw n.url=p.url,n.cookie=t,n}if(!e.withinCookieDomain(p.url,t)){var n=new Error("Http client url scheme is incompatible with cookie secure flag.");throw n.url=p.url,n.cookie=t,n}t.name in p.cookies||(p.cookies[t.name]={}),p.cookies[t.name][t.path]=t,o=!0,r(p)}return o},p.getCookie=function(e,t){var o=null;if(e in p.cookies){var n=p.cookies[e];if(t)t in n&&(o=n[t]);else for(var r in n){o=n[r];break}}return o},p.removeCookie=function(e,t){var o=!1;if(e in p.cookies)if(t){var n=p.cookies[e];if(t in n){o=!0,delete p.cookies[e][t];var i=!0;for(var l in p.cookies[e]){i=!1;break}i&&delete p.cookies[e]}}else o=!0,delete p.cookies[e];return o&&r(p),o},p.clearCookies=function(){p.cookies={},i(p)},forge.log&&forge.log.debug("forge.http","created client",t),p};var f=function(e){return e.replace(/^\s*/,"").replace(/\s*$/,"")},p=function(){var e={fields:{},setField:function(o,n){e.fields[t(o)]=[f(""+n)]},appendField:function(o,n){o=t(o),o in e.fields||(e.fields[o]=[]),e.fields[o].push(f(""+n))},getField:function(o,n){var r=null;return o=t(o),o in e.fields&&(n=n||0,r=e.fields[o][n]),r}};return e},g=function(e){+e+6e4*e.getTimezoneOffset();return Math.floor(+new Date/1e3)};e.createRequest=function(e){e=e||{};var t=p();t.version=e.version||"HTTP/1.1",t.method=e.method||null,t.path=e.path||null,t.body=e.body||null,t.bodyDeflated=!1,t.flashApi=null;var o=e.headers||[];forge.util.isArray(o)||(o=[o]);for(var n=0;n<o.length;++n)for(var r in o[n])t.appendField(r,o[n][r]);return t.addCookie=function(e){var o="",n=t.getField("Cookie");null!==n&&(o=n+"; ");g(new Date);o+=e.name+"="+e.value,t.setField("Cookie",o)},t.toString=function(){null===t.getField("User-Agent")&&t.setField("User-Agent","forge.http 1.0"),null===t.getField("Accept")&&t.setField("Accept","*/*"),null===t.getField("Connection")&&(t.setField("Connection","keep-alive"),t.setField("Keep-Alive","115")),null!==t.flashApi&&null===t.getField("Accept-Encoding")&&t.setField("Accept-Encoding","deflate"),null!==t.flashApi&&null!==t.body&&null===t.getField("Content-Encoding")&&!t.bodyDeflated&&t.body.length>100?(t.body=forge.util.deflate(t.flashApi,t.body),t.bodyDeflated=!0,t.setField("Content-Encoding","deflate"),t.setField("Content-Length",t.body.length)):null!==t.body&&t.setField("Content-Length",t.body.length);var e=t.method.toUpperCase()+" "+t.path+" "+t.version+"\r\n";for(var o in t.fields)for(var n=t.fields[o],r=0;r<n.length;++r)e+=o+": "+n[r]+"\r\n";return e+="\r\n"},t},e.createResponse=function(){var e=!0,t=0,o=!1,n=p();n.version=null,n.code=0,n.message=null,n.body=null,n.headerReceived=!1,n.bodyReceived=!1,n.flashApi=null;var r=function(e){var t=null,o=e.data.indexOf("\r\n",e.read);return-1!=o&&(t=e.getBytes(o-e.read),e.getBytes(2)),t},i=function(e){var t=e.indexOf(":"),o=e.substring(0,t++);n.appendField(o,t<e.length?e.substring(t):"")};n.readHeader=function(t){for(var o="";!n.headerReceived&&null!==o;)if(o=r(t),null!==o)if(e){e=!1;var l=o.split(" ");if(!(l.length>=3)){var s=new Error("Invalid http response header.");throw s.details={line:o},s}n.version=l[0],n.code=parseInt(l[1],10),n.message=l.slice(2).join(" ")}else 0===o.length?n.headerReceived=!0:i(o);return n.headerReceived};var l=function(e){for(var l="";null!==l&&e.length()>0;)if(t>0){if(t+2>e.length())break;n.body+=e.getBytes(t),e.getBytes(2),t=0}else if(o)for(l=r(e);null!==l;)l.length>0?(i(l),l=r(e)):(n.bodyReceived=!0,l=null);else l=r(e),null!==l&&(t=parseInt(l.split(";",1)[0],16),o=0===t);return n.bodyReceived};return n.readBody=function(e){var t=n.getField("Content-Length"),o=n.getField("Transfer-Encoding");if(null!==t&&(t=parseInt(t)),null!==t&&t>=0)n.body=n.body||"",n.body+=e.getBytes(t),n.bodyReceived=n.body.length===t;else if(null!==o){if(-1==o.indexOf("chunked")){var r=new Error("Unknown Transfer-Encoding.");throw r.details={transferEncoding:o},r}n.body=n.body||"",l(e)}else null!==t&&0>t||null===t&&null!==n.getField("Content-Type")?(n.body=n.body||"",n.body+=e.getBytes(),n.readBodyUntilClose=!0):(n.body=null,n.bodyReceived=!0);return n.bodyReceived&&(n.time=+new Date-n.time),null!==n.flashApi&&n.bodyReceived&&null!==n.body&&"deflate"===n.getField("Content-Encoding")&&(n.body=forge.util.inflate(n.flashApi,n.body)),n.bodyReceived},n.getCookies=function(){var e=[];if("Set-Cookie"in n.fields)for(var t=n.fields["Set-Cookie"],o=+new Date/1e3,r=/\s*([^=]*)=?([^;]*)(;|$)/g,i=0;i<t.length;++i){var l,s=t[i];r.lastIndex=0;var a=!0,c={};do if(l=r.exec(s),null!==l){var u=f(l[1]),d=f(l[2]);if(a)c.name=u,c.value=d,a=!1;else switch(u=u.toLowerCase()){case"expires":d=d.replace(/-/g," ");var p=Date.parse(d)/1e3;c.maxAge=Math.max(0,p-o);break;case"max-age":c.maxAge=parseInt(d,10);break;case"secure":c.secure=!0;break;case"httponly":c.httpOnly=!0;break;default:""!==u&&(c[u]=d)}}while(null!==l&&""!==l[0]);e.push(c)}return e},n.toString=function(){var e=n.version+" "+n.code+" "+n.message+"\r\n";for(var t in n.fields)for(var o=n.fields[t],r=0;r<o.length;++r)e+=t+": "+o[r]+"\r\n";return e+="\r\n"},n},e.parseUrl=forge.util.parseUrl,e.withinCookieDomain=function(t,o){var n=!1,r=null===o||"string"==typeof o?o:o.domain;if(null===r)n=!0;else if("."===r.charAt(0)){"string"==typeof t&&(t=e.parseUrl(t));var i="."+t.host,l=i.lastIndexOf(r);-1!==l&&l+r.length===i.length&&(n=!0)}return n},"undefined"==typeof forge&&(forge={}),forge.http=e}();