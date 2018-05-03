<%@page import="java.security.InvalidKeyException" %>
<%@page import="java.security.Key" %>
<%@page import="javax.crypto.spec.SecretKeySpec" %>

 
<%!
private String defaultkey = "gnminwon";

    /**

     * 파일암호화에 쓰이는 버퍼 크기 지정

     */

    public final int kBufferSize = 8192;

 

    public java.security.Key key = null;

 

    /**

     * 지정된 비밀키를 가지고 오는 메서드

     * 

     * @return Key 비밀키 클래스

     * @exception Exception

     */

    private java.security.Key getKey() throws Exception {

        byte[] key = defaultkey.getBytes();

        Key skey = new SecretKeySpec(key, "DES"); 

        return skey;

    }

 

    /**

     * 문자열 대칭 암호화

     * 

     * @param ID

     *            비밀키 암호화를 희망하는 문자열

     * @return String 암호화된 ID

     * @throws InvalidEncryptException

     * @exception Exception

     */

    public String encrypt(String ID) {

        if (ID == null || ID.length() == 0)

            return "";

        String outputStr1 = null;

        try {

        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DES/ECB/PKCS5Padding");

        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, getKey());

        String amalgam = ID;

        byte[] inputBytes1 = amalgam.getBytes("UTF8");

        byte[] outputBytes1 = cipher.doFinal(inputBytes1);

        sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();

        outputStr1 = encoder.encode(outputBytes1);

        } catch(Exception e) {

        }

        return outputStr1;

    }

 

    /**

     * 문자열 대칭 복호화

     * @param   codedID  비밀키 복호화를 희망하는 문자열

     * @return  String  복호화된 ID

     * @exception Exception

     */

 public String decrypt(String codedID) throws Exception{

   if ( codedID == null || codedID.length() == 0 ) return "";

   javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DES/ECB/PKCS5Padding");

   cipher.init(javax.crypto.Cipher.DECRYPT_MODE, getKey());

   sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();

  

   byte[] inputBytes1  = decoder.decodeBuffer(codedID);

   byte[] outputBytes2 = cipher.doFinal(inputBytes1);

  

   String strResult = new String(outputBytes2,"UTF8");

   return strResult;

 }

 

    /**

     * 파일 대칭 암호화

     * @param   infile 암호화을 희망하는 파일명

     * @param   outfile 암호화된 파일명

     * @exception Exception

     */

    public void encryptFile(String infile, String outfile) throws Exception{

            javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DES/ECB/PKCS5Padding");

            cipher.init(javax.crypto.Cipher.ENCRYPT_MODE,getKey());

 

            java.io.FileInputStream in = new java.io.FileInputStream(infile);

            java.io.FileOutputStream fileOut = new java.io.FileOutputStream(outfile);

 

            javax.crypto.CipherOutputStream out = new javax.crypto.CipherOutputStream(fileOut, cipher);

            byte[] buffer = new byte[kBufferSize];

            int length;

            while((length = in.read(buffer)) != -1)

                    out.write(buffer,0,length);

            in.close();

            out.close();

    }

    /**

     * 파일 대칭 복호화

     * @param   infile 복호화을 희망하는 파일명

     * @param   outfile 복호화된 파일명

     * @exception Exception

     */

    public void decryptFile(String infile, String outfile) throws Exception{

            javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("DES/ECB/PKCS5Padding");

            cipher.init(javax.crypto.Cipher.DECRYPT_MODE,getKey());

 

            java.io.FileInputStream in = new java.io.FileInputStream(infile);

            java.io.FileOutputStream fileOut = new java.io.FileOutputStream(outfile);

 

            javax.crypto.CipherOutputStream out = new javax.crypto.CipherOutputStream(fileOut, cipher);

            byte[] buffer = new byte[kBufferSize];

            int length;

            while((length = in.read(buffer)) != -1)

                    out.write(buffer,0,length);

            in.close();

            out.close();

    }
%>

 