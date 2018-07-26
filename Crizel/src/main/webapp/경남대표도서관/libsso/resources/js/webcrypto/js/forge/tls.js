/**
 * A Javascript implementation of Transport Layer Security (TLS).
 *
 * @author Dave Longley
 *
 * Copyright (c) 2009-2014 Digital Bazaar, Inc.
 *
 * The TLS Handshake Protocol involves the following steps:
 *
 * - Exchange hello messages to agree on algorithms, exchange random values,
 * and check for session resumption.
 *
 * - Exchange the necessary cryptographic parameters to allow the client and
 * server to agree on a premaster secret.
 *
 * - Exchange certificates and cryptographic information to allow the client
 * and server to authenticate themselves.
 *
 * - Generate a master secret from the premaster secret and exchanged random
 * values.
 *
 * - Provide security parameters to the record layer.
 *
 * - Allow the client and server to verify that their peer has calculated the
 * same security parameters and that the handshake occurred without tampering
 * by an attacker.
 *
 * Up to 4 different messages may be sent during a key exchange. The server
 * certificate, the server key exchange, the client certificate, and the
 * client key exchange.
 *
 * A typical handshake (from the client's perspective).
 *
 * 1. Client sends ClientHello.
 * 2. Client receives ServerHello.
 * 3. Client receives optional Certificate.
 * 4. Client receives optional ServerKeyExchange.
 * 5. Client receives ServerHelloDone.
 * 6. Client sends optional Certificate.
 * 7. Client sends ClientKeyExchange.
 * 8. Client sends optional CertificateVerify.
 * 9. Client sends ChangeCipherSpec.
 * 10. Client sends Finished.
 * 11. Client receives ChangeCipherSpec.
 * 12. Client receives Finished.
 * 13. Client sends/receives application data.
 *
 * To reuse an existing session:
 *
 * 1. Client sends ClientHello with session ID for reuse.
 * 2. Client receives ServerHello with same session ID if reusing.
 * 3. Client receives ChangeCipherSpec message if reusing.
 * 4. Client receives Finished.
 * 5. Client sends ChangeCipherSpec.
 * 6. Client sends Finished.
 *
 * Note: Client ignores HelloRequest if in the middle of a handshake.
 *
 * Record Layer:
 *
 * The record layer fragments information blocks into TLSPlaintext records
 * carrying data in chunks of 2^14 bytes or less. Client message boundaries are
 * not preserved in the record layer (i.e., multiple client messages of the
 * same ContentType MAY be coalesced into a single TLSPlaintext record, or a
 * single message MAY be fragmented across several records).
 *
 * struct {
 *   uint8 major;
 *   uint8 minor;
 * } ProtocolVersion;
 *
 * struct {
 *   ContentType type;
 *   ProtocolVersion version;
 *   uint16 length;
 *   opaque fragment[TLSPlaintext.length];
 * } TLSPlaintext;
 *
 * type:
 *   The higher-level protocol used to process the enclosed fragment.
 *
 * version:
 *   The version of the protocol being employed. TLS Version 1.2 uses version
 *   {3, 3}. TLS Version 1.0 uses version {3, 1}. Note that a client that
 *   supports multiple versions of TLS may not know what version will be
 *   employed before it receives the ServerHello.
 *
 * length:
 *   The length (in bytes) of the following TLSPlaintext.fragment. The length
 *   MUST NOT exceed 2^14 = 16384 bytes.
 *
 * fragment:
 *   The application data. This data is transparent and treated as an
 *   independent block to be dealt with by the higher-level protocol specified
 *   by the type field.
 *
 * Implementations MUST NOT send zero-length fragments of Handshake, Alert, or
 * ChangeCipherSpec content types. Zero-length fragments of Application data
 * MAY be sent as they are potentially useful as a traffic analysis
 * countermeasure.
 *
 * Note: Data of different TLS record layer content types MAY be interleaved.
 * Application data is generally of lower precedence for transmission than
 * other content types. However, records MUST be delivered to the network in
 * the same order as they are protected by the record layer. Recipients MUST
 * receive and process interleaved application layer traffic during handshakes
 * subsequent to the first one on a connection.
 *
 * struct {
 *   ContentType type;       // same as TLSPlaintext.type
 *   ProtocolVersion version;// same as TLSPlaintext.version
 *   uint16 length;
 *   opaque fragment[TLSCompressed.length];
 * } TLSCompressed;
 *
 * length:
 *   The length (in bytes) of the following TLSCompressed.fragment.
 *   The length MUST NOT exceed 2^14 + 1024.
 *
 * fragment:
 *   The compressed form of TLSPlaintext.fragment.
 *
 * Note: A CompressionMethod.null operation is an identity operation; no fields
 * are altered. In this implementation, since no compression is supported,
 * uncompressed records are always the same as compressed records.
 *
 * Encryption Information:
 *
 * The encryption and MAC functions translate a TLSCompressed structure into a
 * TLSCiphertext. The decryption functions reverse the process. The MAC of the
 * record also includes a sequence number so that missing, extra, or repeated
 * messages are detectable.
 *
 * struct {
 *   ContentType type;
 *   ProtocolVersion version;
 *   uint16 length;
 *   select (SecurityParameters.cipher_type) {
 *     case stream: GenericStreamCipher;
 *     case block:  GenericBlockCipher;
 *     case aead:   GenericAEADCipher;
 *   } fragment;
 * } TLSCiphertext;
 *
 * type:
 *   The type field is identical to TLSCompressed.type.
 *
 * version:
 *   The version field is identical to TLSCompressed.version.
 *
 * length:
 *   The length (in bytes) of the following TLSCiphertext.fragment.
 *   The length MUST NOT exceed 2^14 + 2048.
 *
 * fragment:
 *   The encrypted form of TLSCompressed.fragment, with the MAC.
 *
 * Note: Only CBC Block Ciphers are supported by this implementation.
 *
 * The TLSCompressed.fragment structures are converted to/from block
 * TLSCiphertext.fragment structures.
 *
 * struct {
 *   opaque IV[SecurityParameters.record_iv_length];
 *   block-ciphered struct {
 *     opaque content[TLSCompressed.length];
 *     opaque MAC[SecurityParameters.mac_length];
 *     uint8 padding[GenericBlockCipher.padding_length];
 *     uint8 padding_length;
 *   };
 * } GenericBlockCipher;
 *
 * The MAC is generated as described in Section 6.2.3.1.
 *
 * IV:
 *   The Initialization Vector (IV) SHOULD be chosen at random, and MUST be
 *   unpredictable. Note that in versions of TLS prior to 1.1, there was no
 *   IV field, and the last ciphertext block of the previous record (the "CBC
 *   residue") was used as the IV. This was changed to prevent the attacks
 *   described in [CBCATT]. For block ciphers, the IV length is of length
 *   SecurityParameters.record_iv_length, which is equal to the
 *   SecurityParameters.block_size.
 *
 * padding:
 *   Padding that is added to force the length of the plaintext to be an
 *   integral multiple of the block cipher's block length. The padding MAY be
 *   any length up to 255 bytes, as long as it results in the
 *   TLSCiphertext.length being an integral multiple of the block length.
 *   Lengths longer than necessary might be desirable to frustrate attacks on
 *   a protocol that are based on analysis of the lengths of exchanged
 *   messages. Each uint8 in the padding data vector MUST be filled with the
 *   padding length value. The receiver MUST check this padding and MUST use
 *   the bad_record_mac alert to indicate padding errors.
 *
 * padding_length:
 *   The padding length MUST be such that the total size of the
 *   GenericBlockCipher structure is a multiple of the cipher's block length.
 *   Legal values range from zero to 255, inclusive. This length specifies the
 *   length of the padding field exclusive of the padding_length field itself.
 *
 * The encrypted data length (TLSCiphertext.length) is one more than the sum of
 * SecurityParameters.block_length, TLSCompressed.length,
 * SecurityParameters.mac_length, and padding_length.
 *
 * Example: If the block length is 8 bytes, the content length
 * (TLSCompressed.length) is 61 bytes, and the MAC length is 20 bytes, then the
 * length before padding is 82 bytes (this does not include the IV. Thus, the
 * padding length modulo 8 must be equal to 6 in order to make the total length
 * an even multiple of 8 bytes (the block length). The padding length can be
 * 6, 14, 22, and so on, through 254. If the padding length were the minimum
 * necessary, 6, the padding would be 6 bytes, each containing the value 6.
 * Thus, the last 8 octets of the GenericBlockCipher before block encryption
 * would be xx 06 06 06 06 06 06 06, where xx is the last octet of the MAC.
 *
 * Note: With block ciphers in CBC mode (Cipher Block Chaining), it is critical
 * that the entire plaintext of the record be known before any ciphertext is
 * transmitted. Otherwise, it is possible for the attacker to mount the attack
 * described in [CBCATT].
 *
 * Implementation note: Canvel et al. [CBCTIME] have demonstrated a timing
 * attack on CBC padding based on the time required to compute the MAC. In
 * order to defend against this attack, implementations MUST ensure that
 * record processing time is essentially the same whether or not the padding
 * is correct. In general, the best way to do this is to compute the MAC even
 * if the padding is incorrect, and only then reject the packet. For instance,
 * if the pad appears to be incorrect, the implementation might assume a
 * zero-length pad and then compute the MAC. This leaves a small timing
 * channel, since MAC performance depends, to some extent, on the size of the
 * data fragment, but it is not believed to be large enough to be exploitable,
 * due to the large block size of existing MACs and the small size of the
 * timing signal.
 */
!function(){function e(e){var t=function(t,r,n,i){var a=e.util.createBuffer(),s=t.length>>1,o=s+(1&t.length),c=t.substr(0,o),l=t.substr(s,o),u=e.util.createBuffer(),p=e.hmac.create();n=r+n;var d=Math.ceil(i/16),f=Math.ceil(i/20);p.start("MD5",c);var h=e.util.createBuffer();u.putBytes(n);for(var v=0;d>v;++v)p.start(null,null),p.update(u.getBytes()),u.putBuffer(p.digest()),p.start(null,null),p.update(u.bytes()+n),h.putBuffer(p.digest());p.start("SHA1",l);var g=e.util.createBuffer();u.clear(),u.putBytes(n);for(var v=0;f>v;++v)p.start(null,null),p.update(u.getBytes()),u.putBuffer(p.digest()),p.start(null,null),p.update(u.bytes()+n),g.putBuffer(p.digest());return a.putBytes(e.util.xorBytes(h.getBytes(),g.getBytes(),i)),a},r=function(t,r,n){var i=e.hmac.create();i.start("SHA1",t);var a=e.util.createBuffer();return a.putInt32(r[0]),a.putInt32(r[1]),a.putByte(n.type),a.putByte(n.version.major),a.putByte(n.version.minor),a.putInt16(n.length),a.putBytes(n.fragment.bytes()),i.update(a.getBytes()),i.digest().getBytes()},n=function(t,r){var n=!1;try{var i=t.deflate(r.fragment.getBytes());r.fragment=e.util.createBuffer(i),r.length=i.length,n=!0}catch(a){}return n},i=function(t,r){var n=!1;try{var i=t.inflate(r.fragment.getBytes());r.fragment=e.util.createBuffer(i),r.length=i.length,n=!0}catch(a){}return n},a=function(t,r){var n=0;switch(r){case 1:n=t.getByte();break;case 2:n=t.getInt16();break;case 3:n=t.getInt24();break;case 4:n=t.getInt32()}return e.util.createBuffer(t.getBytes(n))},s=function(e,t,r){e.putInt(r.length(),t<<3),e.putBuffer(r)},o={};o.Versions={TLS_1_0:{major:3,minor:1},TLS_1_1:{major:3,minor:2},TLS_1_2:{major:3,minor:3}},o.SupportedVersions=[o.Versions.TLS_1_1,o.Versions.TLS_1_0],o.Version=o.SupportedVersions[0],o.MaxFragment=15360,o.ConnectionEnd={server:0,client:1},o.PRFAlgorithm={tls_prf_sha256:0},o.BulkCipherAlgorithm={none:null,rc4:0,des3:1,aes:2},o.CipherType={stream:0,block:1,aead:2},o.MACAlgorithm={none:null,hmac_md5:0,hmac_sha1:1,hmac_sha256:2,hmac_sha384:3,hmac_sha512:4},o.CompressionMethod={none:0,deflate:1},o.ContentType={change_cipher_spec:20,alert:21,handshake:22,application_data:23,heartbeat:24},o.HandshakeType={hello_request:0,client_hello:1,server_hello:2,certificate:11,server_key_exchange:12,certificate_request:13,server_hello_done:14,certificate_verify:15,client_key_exchange:16,finished:20},o.Alert={},o.Alert.Level={warning:1,fatal:2},o.Alert.Description={close_notify:0,unexpected_message:10,bad_record_mac:20,decryption_failed:21,record_overflow:22,decompression_failure:30,handshake_failure:40,bad_certificate:42,unsupported_certificate:43,certificate_revoked:44,certificate_expired:45,certificate_unknown:46,illegal_parameter:47,unknown_ca:48,access_denied:49,decode_error:50,decrypt_error:51,export_restriction:60,protocol_version:70,insufficient_security:71,internal_error:80,user_canceled:90,no_renegotiation:100},o.HeartbeatMessageType={heartbeat_request:1,heartbeat_response:2},o.CipherSuites={},o.getCipherSuite=function(e){var t=null;for(var r in o.CipherSuites){var n=o.CipherSuites[r];if(n.id[0]===e.charCodeAt(0)&&n.id[1]===e.charCodeAt(1)){t=n;break}}return t},o.handleUnexpected=function(e){var t=!e.open&&e.entity===o.ConnectionEnd.client;t||e.error(e,{message:"Unexpected message. Received TLS record out of order.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.unexpected_message}})},o.handleHelloRequest=function(e){!e.handshaking&&e.handshakes>0&&(o.queue(e,o.createAlert(e,{level:o.Alert.Level.warning,description:o.Alert.Description.no_renegotiation})),o.flush(e)),e.process()},o.parseHelloMessage=function(t,r,n){var i=null,s=t.entity===o.ConnectionEnd.client;if(38>n)t.error(t,{message:s?"Invalid ServerHello message. Message too short.":"Invalid ClientHello message. Message too short.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}});else{var c=r.fragment,l=c.length();if(i={version:{major:c.getByte(),minor:c.getByte()},random:e.util.createBuffer(c.getBytes(32)),session_id:a(c,1),extensions:[]},s?(i.cipher_suite=c.getBytes(2),i.compression_method=c.getByte()):(i.cipher_suites=a(c,2),i.compression_methods=a(c,1)),l=n-(l-c.length()),l>0){for(var u=a(c,2);u.length()>0;)i.extensions.push({type:[u.getByte(),u.getByte()],data:a(u,2)});if(!s)for(var p=0;p<i.extensions.length;++p){var d=i.extensions[p];if(0===d.type[0]&&0===d.type[1])for(var f=a(d.data,2);f.length()>0;){var h=f.getByte();if(0!==h)break;t.session.extensions.server_name.serverNameList.push(a(f,2).getBytes())}}}if(t.session.version&&(i.version.major!==t.session.version.major||i.version.minor!==t.session.version.minor))return t.error(t,{message:"TLS version change is disallowed during renegotiation.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.protocol_version}});if(s)t.session.cipherSuite=o.getCipherSuite(i.cipher_suite);else for(var v=e.util.createBuffer(i.cipher_suites.bytes());v.length()>0&&(t.session.cipherSuite=o.getCipherSuite(v.getBytes(2)),null===t.session.cipherSuite););if(null===t.session.cipherSuite)return t.error(t,{message:"No cipher suites in common.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.handshake_failure},cipherSuite:e.util.bytesToHex(i.cipher_suite)});t.session.compressionMethod=s?i.compression_method:o.CompressionMethod.none}return i},o.createSecurityParameters=function(e,t){var r=e.entity===o.ConnectionEnd.client,n=t.random.bytes(),i=r?e.session.sp.client_random:n,a=r?n:o.createRandom().getBytes();e.session.sp={entity:e.entity,prf_algorithm:o.PRFAlgorithm.tls_prf_sha256,bulk_cipher_algorithm:null,cipher_type:null,enc_key_length:null,block_length:null,fixed_iv_length:null,record_iv_length:null,mac_algorithm:null,mac_length:null,mac_key_length:null,compression_algorithm:e.session.compressionMethod,pre_master_secret:null,master_secret:null,client_random:i,server_random:a}},o.handleServerHello=function(e,t,r){var n=o.parseHelloMessage(e,t,r);if(!e.fail){if(!(n.version.minor<=e.version.minor))return e.error(e,{message:"Incompatible TLS version.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.protocol_version}});e.version.minor=n.version.minor,e.session.version=e.version;var i=n.session_id.bytes();i.length>0&&i===e.session.id?(e.expect=f,e.session.resuming=!0,e.session.sp.server_random=n.random.bytes()):(e.expect=l,e.session.resuming=!1,o.createSecurityParameters(e,n)),e.session.id=i,e.process()}},o.handleClientHello=function(t,r,n){var i=o.parseHelloMessage(t,r,n);if(!t.fail){var a=i.session_id.bytes(),s=null;if(t.sessionCache&&(s=t.sessionCache.getSession(a),null===s?a="":(s.version.major!==i.version.major||s.version.minor>i.version.minor)&&(s=null,a="")),0===a.length&&(a=e.random.getBytes(32)),t.session.id=a,t.session.clientHelloVersion=i.version,t.session.sp={},s)t.version=t.session.version=s.version,t.session.sp=s.sp;else{for(var c,l=1;l<o.SupportedVersions.length&&(c=o.SupportedVersions[l],!(c.minor<=i.version.minor));++l);t.version={major:c.major,minor:c.minor},t.session.version=t.version}null!==s?(t.expect=B,t.session.resuming=!0,t.session.sp.client_random=i.random.bytes()):(t.expect=t.verifyClient!==!1?m:_,t.session.resuming=!1,o.createSecurityParameters(t,i)),t.open=!0,o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createServerHello(t)})),t.session.resuming?(o.queue(t,o.createRecord(t,{type:o.ContentType.change_cipher_spec,data:o.createChangeCipherSpec()})),t.state.pending=o.createConnectionState(t),t.state.current.write=t.state.pending.write,o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createFinished(t)}))):(o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createCertificate(t)})),t.fail||(o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createServerKeyExchange(t)})),t.verifyClient!==!1&&o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createCertificateRequest(t)})),o.queue(t,o.createRecord(t,{type:o.ContentType.handshake,data:o.createServerHelloDone(t)})))),o.flush(t),t.process()}},o.handleCertificate=function(t,r,n){if(3>n)return t.error(t,{message:"Invalid Certificate message. Message too short.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}});var i,s,c=r.fragment,l={certificate_list:a(c,3)},p=[];try{for(;l.certificate_list.length()>0;)i=a(l.certificate_list,3),s=e.asn1.fromDer(i),i=e.pki.certificateFromAsn1(s,!0),p.push(i)}catch(d){return t.error(t,{message:"Could not parse certificate list.",cause:d,send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.bad_certificate}})}var f=t.entity===o.ConnectionEnd.client;!f&&t.verifyClient!==!0||0!==p.length?0===p.length?t.expect=f?u:_:(f?t.session.serverCertificate=p[0]:t.session.clientCertificate=p[0],o.verifyCertificateChain(t,p)&&(t.expect=f?u:_)):t.error(t,{message:f?"No server certificate provided.":"No client certificate provided.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}}),t.process()},o.handleServerKeyExchange=function(e,t,r){return r>0?e.error(e,{message:"Invalid key parameters. Only RSA is supported.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.unsupported_certificate}}):(e.expect=p,void e.process())},o.handleClientKeyExchange=function(t,r,n){if(48>n)return t.error(t,{message:"Invalid key parameters. Only RSA is supported.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.unsupported_certificate}});var i=r.fragment,s={enc_pre_master_secret:a(i,2).getBytes()},c=null;if(t.getPrivateKey)try{c=t.getPrivateKey(t,t.session.serverCertificate),c=e.pki.privateKeyFromPem(c)}catch(l){t.error(t,{message:"Could not get private key.",cause:l,send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}})}if(null===c)return t.error(t,{message:"No private key set.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}});try{var u=t.session.sp;u.pre_master_secret=c.decrypt(s.enc_pre_master_secret);var p=t.session.clientHelloVersion;if(p.major!==u.pre_master_secret.charCodeAt(0)||p.minor!==u.pre_master_secret.charCodeAt(1))throw new Error("TLS version rollback attack detected.")}catch(l){u.pre_master_secret=e.random.getBytes(48)}t.expect=B,null!==t.session.clientCertificate&&(t.expect=C),t.process()},o.handleCertificateRequest=function(e,t,r){if(3>r)return e.error(e,{message:"Invalid CertificateRequest. Message too short.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}});var n=t.fragment,i={certificate_types:a(n,1),certificate_authorities:a(n,2)};e.session.certificateRequest=i,e.expect=d,e.process()},o.handleCertificateVerify=function(t,r,n){if(2>n)return t.error(t,{message:"Invalid CertificateVerify. Message too short.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}});var i=r.fragment;i.read-=4;var s=i.bytes();i.read+=4;var c={signature:a(i,2).getBytes()},l=e.util.createBuffer();l.putBuffer(t.session.md5.digest()),l.putBuffer(t.session.sha1.digest()),l=l.getBytes();try{var u=t.session.clientCertificate;if(!u.publicKey.verify(l,c.signature,"NONE"))throw new Error("CertificateVerify signature does not match.");t.session.md5.update(s),t.session.sha1.update(s)}catch(p){return t.error(t,{message:"Bad signature in CertificateVerify.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.handshake_failure}})}t.expect=B,t.process()},o.handleServerHelloDone=function(t,r,n){if(n>0)return t.error(t,{message:"Invalid ServerHelloDone message. Invalid length.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.record_overflow}});if(null===t.serverCertificate){var i={message:"No server certificate provided. Not enough security.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.insufficient_security}},a=0,s=t.verify(t,i.alert.description,a,[]);if(s!==!0)return(s||0===s)&&("object"!=typeof s||e.util.isArray(s)?"number"==typeof s&&(i.alert.description=s):(s.message&&(i.message=s.message),s.alert&&(i.alert.description=s.alert))),t.error(t,i)}null!==t.session.certificateRequest&&(r=o.createRecord(t,{type:o.ContentType.handshake,data:o.createCertificate(t)}),o.queue(t,r)),r=o.createRecord(t,{type:o.ContentType.handshake,data:o.createClientKeyExchange(t)}),o.queue(t,r),t.expect=g;var c=function(e,t){null!==e.session.certificateRequest&&null!==e.session.clientCertificate&&o.queue(e,o.createRecord(e,{type:o.ContentType.handshake,data:o.createCertificateVerify(e,t)})),o.queue(e,o.createRecord(e,{type:o.ContentType.change_cipher_spec,data:o.createChangeCipherSpec()})),e.state.pending=o.createConnectionState(e),e.state.current.write=e.state.pending.write,o.queue(e,o.createRecord(e,{type:o.ContentType.handshake,data:o.createFinished(e)})),e.expect=f,o.flush(e),e.process()};return null===t.session.certificateRequest||null===t.session.clientCertificate?c(t,null):void o.getClientSignature(t,c)},o.handleChangeCipherSpec=function(e,t){if(1!==t.fragment.getByte())return e.error(e,{message:"Invalid ChangeCipherSpec message received.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.illegal_parameter}});var r=e.entity===o.ConnectionEnd.client;(e.session.resuming&&r||!e.session.resuming&&!r)&&(e.state.pending=o.createConnectionState(e)),e.state.current.read=e.state.pending.read,(!e.session.resuming&&r||e.session.resuming&&!r)&&(e.state.pending=null),e.expect=r?h:k,e.process()},o.handleFinished=function(r,n){var i=n.fragment;i.read-=4;var a=i.bytes();i.read+=4;var s=n.fragment.getBytes();i=e.util.createBuffer(),i.putBuffer(r.session.md5.digest()),i.putBuffer(r.session.sha1.digest());var c=r.entity===o.ConnectionEnd.client,l=c?"server finished":"client finished",u=r.session.sp,p=12,d=t;return i=d(u.master_secret,l,i.getBytes(),p),i.getBytes()!==s?r.error(r,{message:"Invalid verify_data in Finished message.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.decrypt_error}}):(r.session.md5.update(a),r.session.sha1.update(a),(r.session.resuming&&c||!r.session.resuming&&!c)&&(o.queue(r,o.createRecord(r,{type:o.ContentType.change_cipher_spec,data:o.createChangeCipherSpec()})),r.state.current.write=r.state.pending.write,r.state.pending=null,o.queue(r,o.createRecord(r,{type:o.ContentType.handshake,data:o.createFinished(r)}))),r.expect=c?v:A,r.handshaking=!1,++r.handshakes,r.peerCertificate=c?r.session.serverCertificate:r.session.clientCertificate,o.flush(r),r.isConnected=!0,r.connected(r),void r.process())},o.handleAlert=function(e,t){var r,n=t.fragment,i={level:n.getByte(),description:n.getByte()};switch(i.description){case o.Alert.Description.close_notify:r="Connection closed.";break;case o.Alert.Description.unexpected_message:r="Unexpected message.";break;case o.Alert.Description.bad_record_mac:r="Bad record MAC.";break;case o.Alert.Description.decryption_failed:r="Decryption failed.";break;case o.Alert.Description.record_overflow:r="Record overflow.";break;case o.Alert.Description.decompression_failure:r="Decompression failed.";break;case o.Alert.Description.handshake_failure:r="Handshake failure.";break;case o.Alert.Description.bad_certificate:r="Bad certificate.";break;case o.Alert.Description.unsupported_certificate:r="Unsupported certificate.";break;case o.Alert.Description.certificate_revoked:r="Certificate revoked.";break;case o.Alert.Description.certificate_expired:r="Certificate expired.";break;case o.Alert.Description.certificate_unknown:r="Certificate unknown.";break;case o.Alert.Description.illegal_parameter:r="Illegal parameter.";break;case o.Alert.Description.unknown_ca:r="Unknown certificate authority.";break;case o.Alert.Description.access_denied:r="Access denied.";break;case o.Alert.Description.decode_error:r="Decode error.";break;case o.Alert.Description.decrypt_error:r="Decrypt error.";break;case o.Alert.Description.export_restriction:r="Export restriction.";break;case o.Alert.Description.protocol_version:r="Unsupported protocol version.";break;case o.Alert.Description.insufficient_security:r="Insufficient security.";break;case o.Alert.Description.internal_error:r="Internal error.";break;case o.Alert.Description.user_canceled:r="User canceled.";break;case o.Alert.Description.no_renegotiation:r="Renegotiation not supported.";break;default:r="Unknown error."}return i.description===o.Alert.Description.close_notify?e.close():(e.error(e,{message:r,send:!1,origin:e.entity===o.ConnectionEnd.client?"server":"client",alert:i}),void e.process())},o.handleHandshake=function(t,r){var n=r.fragment,i=n.getByte(),a=n.getInt24();if(a>n.length())return t.fragmented=r,r.fragment=e.util.createBuffer(),n.read-=4,t.process();t.fragmented=null,n.read-=4;var s=n.bytes(a+4);n.read+=4,i in F[t.entity][t.expect]?(t.entity!==o.ConnectionEnd.server||t.open||t.fail||(t.handshaking=!0,t.session={version:null,extensions:{server_name:{serverNameList:[]}},cipherSuite:null,compressionMethod:null,serverCertificate:null,clientCertificate:null,md5:e.md.md5.create(),sha1:e.md.sha1.create()}),i!==o.HandshakeType.hello_request&&i!==o.HandshakeType.certificate_verify&&i!==o.HandshakeType.finished&&(t.session.md5.update(s),t.session.sha1.update(s)),F[t.entity][t.expect][i](t,r,a)):o.handleUnexpected(t,r)},o.handleApplicationData=function(e,t){e.data.putBuffer(t.fragment),e.dataReady(e),e.process()},o.handleHeartbeat=function(t,r){var n=r.fragment,i=n.getByte(),a=n.getInt16(),s=n.getBytes(a);if(i===o.HeartbeatMessageType.heartbeat_request){if(t.handshaking||a>s.length)return t.process();o.queue(t,o.createRecord(t,{type:o.ContentType.heartbeat,data:o.createHeartbeat(o.HeartbeatMessageType.heartbeat_response,s)})),o.flush(t)}else if(i===o.HeartbeatMessageType.heartbeat_response){if(s!==t.expectedHeartbeatPayload)return t.process();t.heartbeatReceived&&t.heartbeatReceived(t,e.util.createBuffer(s))}t.process()};var c=0,l=1,u=2,p=3,d=4,f=5,h=6,v=7,g=8,y=0,m=1,_=2,C=3,B=4,k=5,A=6,b=o.handleUnexpected,S=o.handleChangeCipherSpec,D=o.handleAlert,T=o.handleHandshake,x=o.handleApplicationData,E=o.handleHeartbeat,w=[];w[o.ConnectionEnd.client]=[[b,D,T,b,E],[b,D,T,b,E],[b,D,T,b,E],[b,D,T,b,E],[b,D,T,b,E],[S,D,b,b,E],[b,D,T,b,E],[b,D,T,x,E],[b,D,T,b,E]],w[o.ConnectionEnd.server]=[[b,D,T,b,E],[b,D,T,b,E],[b,D,T,b,E],[b,D,T,b,E],[S,D,b,b,E],[b,D,T,b,E],[b,D,T,x,E],[b,D,T,b,E]];var R=o.handleHelloRequest,H=o.handleServerHello,I=o.handleCertificate,q=o.handleServerKeyExchange,L=o.handleCertificateRequest,M=o.handleServerHelloDone,j=o.handleFinished,F=[];F[o.ConnectionEnd.client]=[[b,b,H,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,I,q,L,M,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,q,L,M,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,b,L,M,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,b,b,M,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,j],[R,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[R,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]];var V=o.handleClientHello,K=o.handleClientKeyExchange,P=o.handleCertificateVerify;F[o.ConnectionEnd.server]=[[b,V,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,I,b,b,b,b,b,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,K,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,P,b,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,j],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]],o.generateKeys=function(e,r){var n=t,i=r.client_random+r.server_random;e.session.resuming||(r.master_secret=n(r.pre_master_secret,"master secret",i,48).bytes(),r.pre_master_secret=null),i=r.server_random+r.client_random;var a=2*r.mac_key_length+2*r.enc_key_length,s=e.version.major===o.Versions.TLS_1_0.major&&e.version.minor===o.Versions.TLS_1_0.minor;s&&(a+=2*r.fixed_iv_length);var c=n(r.master_secret,"key expansion",i,a),l={client_write_MAC_key:c.getBytes(r.mac_key_length),server_write_MAC_key:c.getBytes(r.mac_key_length),client_write_key:c.getBytes(r.enc_key_length),server_write_key:c.getBytes(r.enc_key_length)};return s&&(l.client_write_IV=c.getBytes(r.fixed_iv_length),l.server_write_IV=c.getBytes(r.fixed_iv_length)),l},o.createConnectionState=function(e){var t=e.entity===o.ConnectionEnd.client,r=function(){var e={sequenceNumber:[0,0],macKey:null,macLength:0,macFunction:null,cipherState:null,cipherFunction:function(){return!0},compressionState:null,compressFunction:function(){return!0},updateSequenceNumber:function(){4294967295===e.sequenceNumber[1]?(e.sequenceNumber[1]=0,++e.sequenceNumber[0]):++e.sequenceNumber[1]}};return e},a={read:r(),write:r()};if(a.read.update=function(e,t){return a.read.cipherFunction(t,a.read)?a.read.compressFunction(e,t,a.read)||e.error(e,{message:"Could not decompress record.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.decompression_failure}}):e.error(e,{message:"Could not decrypt record or bad MAC.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.bad_record_mac}}),!e.fail},a.write.update=function(e,t){return a.write.compressFunction(e,t,a.write)?a.write.cipherFunction(t,a.write)||e.error(e,{message:"Could not encrypt record.",send:!1,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}}):e.error(e,{message:"Could not compress record.",send:!1,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}}),!e.fail},e.session){var s=e.session.sp;switch(e.session.cipherSuite.initSecurityParameters(s),s.keys=o.generateKeys(e,s),a.read.macKey=t?s.keys.server_write_MAC_key:s.keys.client_write_MAC_key,a.write.macKey=t?s.keys.client_write_MAC_key:s.keys.server_write_MAC_key,e.session.cipherSuite.initConnectionState(a,e,s),s.compression_algorithm){case o.CompressionMethod.none:break;case o.CompressionMethod.deflate:a.read.compressFunction=i,a.write.compressFunction=n;break;default:throw new Error("Unsupported compression algorithm.")}}return a},o.createRandom=function(){var t=new Date,r=+t+6e4*t.getTimezoneOffset(),n=e.util.createBuffer();return n.putInt32(r),n.putBytes(e.random.getBytes(28)),n},o.createRecord=function(e,t){if(!t.data)return null;var r={type:t.type,version:{major:e.version.major,minor:e.version.minor},length:t.data.length(),fragment:t.data};return r},o.createAlert=function(t,r){var n=e.util.createBuffer();return n.putByte(r.level),n.putByte(r.description),o.createRecord(t,{type:o.ContentType.alert,data:n})},o.createClientHello=function(t){t.session.clientHelloVersion={major:t.version.major,minor:t.version.minor};for(var r=e.util.createBuffer(),n=0;n<t.cipherSuites.length;++n){var i=t.cipherSuites[n];r.putByte(i.id[0]),r.putByte(i.id[1])}var a=r.length(),c=e.util.createBuffer();c.putByte(o.CompressionMethod.none);var l=c.length(),u=e.util.createBuffer();if(t.virtualHost){var p=e.util.createBuffer();p.putByte(0),p.putByte(0);var d=e.util.createBuffer();d.putByte(0),s(d,2,e.util.createBuffer(t.virtualHost));var f=e.util.createBuffer();s(f,2,d),s(p,2,f),u.putBuffer(p)}var h=u.length();h>0&&(h+=2);var v=t.session.id,g=v.length+1+2+4+28+2+a+1+l+h,y=e.util.createBuffer();return y.putByte(o.HandshakeType.client_hello),y.putInt24(g),y.putByte(t.version.major),y.putByte(t.version.minor),y.putBytes(t.session.sp.client_random),s(y,1,e.util.createBuffer(v)),s(y,2,r),s(y,1,c),h>0&&s(y,2,u),y},o.createServerHello=function(t){var r=t.session.id,n=r.length+1+2+4+28+2+1,i=e.util.createBuffer();return i.putByte(o.HandshakeType.server_hello),i.putInt24(n),i.putByte(t.version.major),i.putByte(t.version.minor),i.putBytes(t.session.sp.server_random),s(i,1,e.util.createBuffer(r)),i.putByte(t.session.cipherSuite.id[0]),i.putByte(t.session.cipherSuite.id[1]),i.putByte(t.session.compressionMethod),i},o.createCertificate=function(t){var r=t.entity===o.ConnectionEnd.client,n=null;if(t.getCertificate){var i;i=r?t.session.certificateRequest:t.session.extensions.server_name.serverNameList,n=t.getCertificate(t,i)}var a=e.util.createBuffer();if(null!==n)try{e.util.isArray(n)||(n=[n]);for(var c=null,l=0;l<n.length;++l){var u=e.pem.decode(n[l])[0];if("CERTIFICATE"!==u.type&&"X509 CERTIFICATE"!==u.type&&"TRUSTED CERTIFICATE"!==u.type){var p=new Error('Could not convert certificate from PEM; PEM header type is not "CERTIFICATE", "X509 CERTIFICATE", or "TRUSTED CERTIFICATE".');throw p.headerType=u.type,p}if(u.procType&&"ENCRYPTED"===u.procType.type)throw new Error("Could not convert certificate from PEM; PEM is encrypted.");var d=e.util.createBuffer(u.body);null===c&&(c=e.asn1.fromDer(d.bytes(),!1));var f=e.util.createBuffer();s(f,3,d),a.putBuffer(f)}n=e.pki.certificateFromAsn1(c),r?t.session.clientCertificate=n:t.session.serverCertificate=n}catch(h){return t.error(t,{message:"Could not send certificate list.",cause:h,send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.bad_certificate}})}var v=3+a.length(),g=e.util.createBuffer();return g.putByte(o.HandshakeType.certificate),g.putInt24(v),s(g,3,a),g},o.createClientKeyExchange=function(t){var r=e.util.createBuffer();r.putByte(t.session.clientHelloVersion.major),r.putByte(t.session.clientHelloVersion.minor),r.putBytes(e.random.getBytes(46));var n=t.session.sp;n.pre_master_secret=r.getBytes();var i=t.session.serverCertificate.publicKey;r=i.encrypt(n.pre_master_secret);var a=r.length+2,s=e.util.createBuffer();return s.putByte(o.HandshakeType.client_key_exchange),s.putInt24(a),s.putInt16(r.length),s.putBytes(r),s},o.createServerKeyExchange=function(){var t=0,r=e.util.createBuffer();return t>0&&(r.putByte(o.HandshakeType.server_key_exchange),r.putInt24(t)),r},o.getClientSignature=function(t,r){var n=e.util.createBuffer();n.putBuffer(t.session.md5.digest()),n.putBuffer(t.session.sha1.digest()),n=n.getBytes(),t.getSignature=t.getSignature||function(t,r,n){var i=null;if(t.getPrivateKey)try{i=t.getPrivateKey(t,t.session.clientCertificate),i=e.pki.privateKeyFromPem(i)}catch(a){t.error(t,{message:"Could not get private key.",cause:a,send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}})}null===i?t.error(t,{message:"No private key set.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.internal_error}}):r=i.sign(r,null),n(t,r)},t.getSignature(t,n,r)},o.createCertificateVerify=function(t,r){var n=r.length+2,i=e.util.createBuffer();return i.putByte(o.HandshakeType.certificate_verify),i.putInt24(n),i.putInt16(r.length),i.putBytes(r),i},o.createCertificateRequest=function(t){var r=e.util.createBuffer();r.putByte(1);var n=e.util.createBuffer();for(var i in t.caStore.certs){var a=t.caStore.certs[i],c=e.pki.distinguishedNameToAsn1(a.subject);n.putBuffer(e.asn1.toDer(c))}var l=1+r.length()+2+n.length(),u=e.util.createBuffer();return u.putByte(o.HandshakeType.certificate_request),u.putInt24(l),s(u,1,r),s(u,2,n),u},o.createServerHelloDone=function(){var t=e.util.createBuffer();return t.putByte(o.HandshakeType.server_hello_done),t.putInt24(0),t},o.createChangeCipherSpec=function(){var t=e.util.createBuffer();return t.putByte(1),t},o.createFinished=function(r){var n=e.util.createBuffer();n.putBuffer(r.session.md5.digest()),n.putBuffer(r.session.sha1.digest());var i=r.entity===o.ConnectionEnd.client,a=r.session.sp,s=12,c=t,l=i?"client finished":"server finished";n=c(a.master_secret,l,n.getBytes(),s);var u=e.util.createBuffer();return u.putByte(o.HandshakeType.finished),u.putInt24(n.length()),u.putBuffer(n),u},o.createHeartbeat=function(t,r,n){"undefined"==typeof n&&(n=r.length);var i=e.util.createBuffer();i.putByte(t),i.putInt16(n),i.putBytes(r);var a=i.length(),s=Math.max(16,a-n-3);return i.putBytes(e.random.getBytes(s)),i},o.queue=function(t,r){if(r){if(r.type===o.ContentType.handshake){var n=r.fragment.bytes();t.session.md5.update(n),t.session.sha1.update(n),n=null}var i;if(r.fragment.length()<=o.MaxFragment)i=[r];else{i=[];for(var a=r.fragment.bytes();a.length>o.MaxFragment;)i.push(o.createRecord(t,{type:r.type,data:e.util.createBuffer(a.slice(0,o.MaxFragment))})),a=a.slice(o.MaxFragment);a.length>0&&i.push(o.createRecord(t,{type:r.type,data:e.util.createBuffer(a)}))}for(var s=0;s<i.length&&!t.fail;++s){var c=i[s],l=t.state.current.write;l.update(t,c)&&t.records.push(c)}}},o.flush=function(e){for(var t=0;t<e.records.length;++t){var r=e.records[t];e.tlsData.putByte(r.type),e.tlsData.putByte(r.version.major),e.tlsData.putByte(r.version.minor),e.tlsData.putInt16(r.fragment.length()),e.tlsData.putBuffer(e.records[t].fragment)}return e.records=[],e.tlsDataReady(e)};var N=function(t){switch(t){case!0:return!0;case e.pki.certificateError.bad_certificate:return o.Alert.Description.bad_certificate;case e.pki.certificateError.unsupported_certificate:return o.Alert.Description.unsupported_certificate;case e.pki.certificateError.certificate_revoked:return o.Alert.Description.certificate_revoked;case e.pki.certificateError.certificate_expired:return o.Alert.Description.certificate_expired;case e.pki.certificateError.certificate_unknown:return o.Alert.Description.certificate_unknown;case e.pki.certificateError.unknown_ca:return o.Alert.Description.unknown_ca;default:return o.Alert.Description.bad_certificate}},U=function(t){switch(t){case!0:return!0;case o.Alert.Description.bad_certificate:return e.pki.certificateError.bad_certificate;case o.Alert.Description.unsupported_certificate:return e.pki.certificateError.unsupported_certificate;case o.Alert.Description.certificate_revoked:return e.pki.certificateError.certificate_revoked;case o.Alert.Description.certificate_expired:return e.pki.certificateError.certificate_expired;case o.Alert.Description.certificate_unknown:return e.pki.certificateError.certificate_unknown;case o.Alert.Description.unknown_ca:return e.pki.certificateError.unknown_ca;default:return e.pki.certificateError.bad_certificate}};o.verifyCertificateChain=function(t,r){try{e.pki.verifyCertificateChain(t.caStore,r,function(r,n,i){var a=(N(r),t.verify(t,r,n,i));if(a!==!0){if("object"==typeof a&&!e.util.isArray(a)){var s=new Error("The application rejected the certificate.");throw s.send=!0,s.alert={level:o.Alert.Level.fatal,description:o.Alert.Description.bad_certificate},a.message&&(s.message=a.message),a.alert&&(s.alert.description=a.alert),s}a!==r&&(a=U(a))}return a})}catch(n){var i=n;("object"!=typeof i||e.util.isArray(i))&&(i={send:!0,alert:{level:o.Alert.Level.fatal,description:N(n)}}),"send"in i||(i.send=!0),"alert"in i||(i.alert={level:o.Alert.Level.fatal,description:N(i.error)}),t.error(t,i)}return!t.fail},o.createSessionCache=function(t,r){var n=null;if(t&&t.getSession&&t.setSession&&t.order)n=t;else{n={},n.cache=t||{},n.capacity=Math.max(r||100,1),n.order=[];for(var i in t)n.order.length<=r?n.order.push(i):delete t[i];n.getSession=function(t){var r=null,i=null;if(t?i=e.util.bytesToHex(t):n.order.length>0&&(i=n.order[0]),null!==i&&i in n.cache){r=n.cache[i],delete n.cache[i];for(var a in n.order)if(n.order[a]===i){n.order.splice(a,1);break}}return r},n.setSession=function(t,r){if(n.order.length===n.capacity){var i=n.order.shift();delete n.cache[i]}var i=e.util.bytesToHex(t);n.order.push(i),n.cache[i]=r}}return n},o.createConnection=function(t){var r=null;r=t.caStore?e.util.isArray(t.caStore)?e.pki.createCaStore(t.caStore):t.caStore:e.pki.createCaStore();var n=t.cipherSuites||null;if(null===n){n=[];for(var i in o.CipherSuites)n.push(o.CipherSuites[i])}var a=t.server?o.ConnectionEnd.server:o.ConnectionEnd.client,s=t.sessionCache?o.createSessionCache(t.sessionCache):null,l={version:{major:o.Version.major,minor:o.Version.minor},entity:a,sessionId:t.sessionId,caStore:r,sessionCache:s,cipherSuites:n,connected:t.connected,virtualHost:t.virtualHost||null,verifyClient:t.verifyClient||!1,verify:t.verify||function(e,t){return t},getCertificate:t.getCertificate||null,getPrivateKey:t.getPrivateKey||null,getSignature:t.getSignature||null,input:e.util.createBuffer(),tlsData:e.util.createBuffer(),data:e.util.createBuffer(),tlsDataReady:t.tlsDataReady,
dataReady:t.dataReady,heartbeatReceived:t.heartbeatReceived,closed:t.closed,error:function(e,r){r.origin=r.origin||(e.entity===o.ConnectionEnd.client?"client":"server"),r.send&&(o.queue(e,o.createAlert(e,r.alert)),o.flush(e));var n=r.fatal!==!1;n&&(e.fail=!0),t.error(e,r),n&&e.close(!1)},deflate:t.deflate||null,inflate:t.inflate||null};l.reset=function(e){l.version={major:o.Version.major,minor:o.Version.minor},l.record=null,l.session=null,l.peerCertificate=null,l.state={pending:null,current:null},l.expect=l.entity===o.ConnectionEnd.client?c:y,l.fragmented=null,l.records=[],l.open=!1,l.handshakes=0,l.handshaking=!1,l.isConnected=!1,l.fail=!(e||"undefined"==typeof e),l.input.clear(),l.tlsData.clear(),l.data.clear(),l.state.current=o.createConnectionState(l)},l.reset();var u=function(e,t){var r=t.type-o.ContentType.change_cipher_spec,n=w[e.entity][e.expect];r in n?n[r](e,t):o.handleUnexpected(e,t)},p=function(t){var r=0,n=t.input,i=n.length();if(5>i)r=5-i;else{t.record={type:n.getByte(),version:{major:n.getByte(),minor:n.getByte()},length:n.getInt16(),fragment:e.util.createBuffer(),ready:!1};var a=t.record.version.major===t.version.major;a&&t.session&&t.session.version&&(a=t.record.version.minor===t.version.minor),a||t.error(t,{message:"Incompatible TLS version.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.protocol_version}})}return r},d=function(e){var t=0,r=e.input,n=r.length();if(n<e.record.length)t=e.record.length-n;else{e.record.fragment.putBytes(r.getBytes(e.record.length)),r.compact();var i=e.state.current.read;i.update(e,e.record)&&(null!==e.fragmented&&(e.fragmented.type===e.record.type?(e.fragmented.fragment.putBuffer(e.record.fragment),e.record=e.fragmented):e.error(e,{message:"Invalid fragmented record.",send:!0,alert:{level:o.Alert.Level.fatal,description:o.Alert.Description.unexpected_message}})),e.record.ready=!0)}return t};return l.handshake=function(t){if(l.entity!==o.ConnectionEnd.client)l.error(l,{message:"Cannot initiate handshake as a server.",fatal:!1});else if(l.handshaking)l.error(l,{message:"Handshake already in progress.",fatal:!1});else{l.fail&&!l.open&&0===l.handshakes&&(l.fail=!1),l.handshaking=!0,t=t||"";var r=null;t.length>0&&(l.sessionCache&&(r=l.sessionCache.getSession(t)),null===r&&(t="")),0===t.length&&l.sessionCache&&(r=l.sessionCache.getSession(),null!==r&&(t=r.id)),l.session={id:t,version:null,cipherSuite:null,compressionMethod:null,serverCertificate:null,certificateRequest:null,clientCertificate:null,sp:{},md5:e.md.md5.create(),sha1:e.md.sha1.create()},r&&(l.version=r.version,l.session.sp=r.sp),l.session.sp.client_random=o.createRandom().getBytes(),l.open=!0,o.queue(l,o.createRecord(l,{type:o.ContentType.handshake,data:o.createClientHello(l)})),o.flush(l)}},l.process=function(e){var t=0;return e&&l.input.putBytes(e),l.fail||(null!==l.record&&l.record.ready&&l.record.fragment.isEmpty()&&(l.record=null),null===l.record&&(t=p(l)),l.fail||null===l.record||l.record.ready||(t=d(l)),!l.fail&&null!==l.record&&l.record.ready&&u(l,l.record)),t},l.prepare=function(t){return o.queue(l,o.createRecord(l,{type:o.ContentType.application_data,data:e.util.createBuffer(t)})),o.flush(l)},l.prepareHeartbeatRequest=function(t,r){return t instanceof e.util.ByteBuffer&&(t=t.bytes()),"undefined"==typeof r&&(r=t.length),l.expectedHeartbeatPayload=t,o.queue(l,o.createRecord(l,{type:o.ContentType.heartbeat,data:o.createHeartbeat(o.HeartbeatMessageType.heartbeat_request,t,r)})),o.flush(l)},l.close=function(e){if(!l.fail&&l.sessionCache&&l.session){var t={id:l.session.id,version:l.session.version,sp:l.session.sp};t.sp.keys=null,l.sessionCache.setSession(t.id,t)}l.open&&(l.open=!1,l.input.clear(),(l.isConnected||l.handshaking)&&(l.isConnected=l.handshaking=!1,o.queue(l,o.createAlert(l,{level:o.Alert.Level.warning,description:o.Alert.Description.close_notify})),o.flush(l)),l.closed(l)),l.reset(e)},l},e.tls=e.tls||{};for(var O in o)"function"!=typeof o[O]&&(e.tls[O]=o[O]);e.tls.prf_tls1=t,e.tls.hmac_sha1=r,e.tls.createSessionCache=o.createSessionCache,e.tls.createConnection=o.createConnection}var t="tls";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var r=!0;define=function(e,t){t(require,module)}}var n,i=function(r,i){i.exports=function(i){var a=n.map(function(e){return r(e)}).concat(e);if(i=i||{},i.defined=i.defined||{},i.defined[t])return i[t];i.defined[t]=!0;for(var s=0;s<a.length;++s)a[s](i);return i[t]}},a=define;define=function(e,t){return n="string"==typeof e?t.slice(2):e.slice(2),r?(delete define,a.apply(null,Array.prototype.slice.call(arguments,0))):(define=a,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./asn1","./hmac","./md","./pem","./pki","./random","./util"],function(){i.apply(null,Array.prototype.slice.call(arguments,0))})}();