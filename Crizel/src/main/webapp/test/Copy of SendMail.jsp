<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="javax.activation.DataHandler"%>
<%@page import="javax.activation.FileDataSource"%>
<%@page import="javax.mail.internet.MimeBodyPart"%>
<%@page import="javax.mail.internet.MimeMultipart"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
String root = request.getSession().getServletContext().getRealPath("/");
String directory = "/upload_data/test/";
MultipartRequest mr = new MultipartRequest(request, root+directory, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());

Enumeration files = mr.getFileNames();
String fileName = "";
String realFile = "";
String saveFile = "";
String fileExt	= "";
File file = null;

while(files.hasMoreElements()){
	fileName 	= (String)files.nextElement();
	file 		= mr.getFile(fileName);
	realFile 	= mr.getOriginalFileName(fileName);
	saveFile 	= mr.getFilesystemName(fileName);
}

String fromAddr		= mr.getParameter("fromAddr")==null?"":mr.getParameter("fromAddr");
String fromName		= mr.getParameter("fromName")==null?"":mr.getParameter("fromName");
String toAddr		= mr.getParameter("toAddr")==null?"":mr.getParameter("toAddr");
String toName		= mr.getParameter("toName")==null?"":mr.getParameter("toName");
String title		= mr.getParameter("title")==null?"":mr.getParameter("title");
String content		= mr.getParameter("content")==null?"":mr.getParameter("content");
String uploadFile	= mr.getParameter("uploadFile")==null?"":mr.getParameter("uploadFile");
uploadFile = root+directory+realFile;

//먼저 환경 정보를 설정해야 한다.
// 메일 서버 주소를 IP 또는 도메인 명으로 지정한다.
Properties props = System.getProperties();
props.setProperty("mail.smtp.host", "112.163.77.54");
/*p.put("mail.smtp.starttls.enable", "true");    
   p.put("mail.smtp.host", "smtp.gmail.com");      // smtp 서버 호스트
   p.put("mail.smtp.auth","true");
   p.put("mail.smtp.port", "587");                 // gmail 포트
*/		 
// 위 환경 정보로 "메일 세션"을 만들고 빈 메시지를 만든다
Session sessions = Session.getDefaultInstance(props);
MimeMessage msg = new MimeMessage(sessions);
 
try {
    // 발신자, 수신자, 참조자, 제목, 본문 내용 등을 설정한다
    msg.setFrom(new InternetAddress(fromAddr, fromName));
    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddr, toName));
    //msg.addRecipient(Message.RecipientType.TO, new InternetAddress("eee@fff.co.kr", "선덕여왕"));
    //msg.addRecipient(Message.RecipientType.CC, new InternetAddress("ggg@hhh.co.kr", "의자왕"));
    msg.setSubject(title);
    //msg.setContent("본문이 어쩌구저쩌구합니다", "text/html; charset=utf-8");
    
    if(file==null){
    	msg.setContent(content, "text/plain; charset=utf-8");
    }else{
    	MimeMultipart multipart = new MimeMultipart();

        MimeBodyPart part = new MimeBodyPart();
        part.setContent(content, "text/plain; charset=utf-8");
        multipart.addBodyPart(part);
        
        part = new MimeBodyPart();
        
        FileDataSource fds = new FileDataSource(uploadFile);

        part.setDataHandler(new DataHandler(fds));
        part.setFileName(fds.getName());
        multipart.addBodyPart(part);
        
        msg.setContent(multipart);
    }
    
    // 메일을 발신한다
    Transport.send(msg);
    
    out.println("<script>");
    out.println("alert('메일이 전송되었습니다');");
    out.println("location.href='/program/SendMailForm.jsp';");
    out.println("</script>");
} catch (Exception e) {
    // 적절히 처리
    out.println(e.toString());
}

%>	
<%-- 	
<%!
class SendMail{
	public void sendMail(String fromAddr, String fromName, String toAddr, String toName, String title, String content){
		//먼저 환경 정보를 설정해야 한다.
		// 메일 서버 주소를 IP 또는 도메인 명으로 지정한다.
		Properties props = System.getProperties();
		props.setProperty("mail.smtp.host", "127.0.0.1");
		/*p.put("mail.smtp.starttls.enable", "true");    
		   p.put("mail.smtp.host", "smtp.gmail.com");      // smtp 서버 호스트
		   p.put("mail.smtp.auth","true");
		   p.put("mail.smtp.port", "587");                 // gmail 포트
		*/		 
		// 위 환경 정보로 "메일 세션"을 만들고 빈 메시지를 만든다
		Session sessions = Session.getDefaultInstance(props);
		MimeMessage msg = new MimeMessage(sessions);
		 
		try {
		    // 발신자, 수신자, 참조자, 제목, 본문 내용 등을 설정한다
		    msg.setFrom(new InternetAddress(fromAddr, fromName));
		    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddr, toName));
		    //msg.addRecipient(Message.RecipientType.TO, new InternetAddress("eee@fff.co.kr", "선덕여왕"));
		    //msg.addRecipient(Message.RecipientType.CC, new InternetAddress("ggg@hhh.co.kr", "의자왕"));
		    msg.setSubject(title);
		    //msg.setContent("본문이 어쩌구저쩌구합니다", "text/html; charset=utf-8");
		    //msg.setContent(content, "text/plain; charset=utf-8");
		    
		    
		    MimeMultipart multipart = new MimeMultipart();

		    MimeBodyPart part = new MimeBodyPart();
		    part.setContent(content, "text/plain; charset=utf-8");
		    multipart.addBodyPart(part);
		     
		    part = new MimeBodyPart();
		    
		    FileDataSource fds = new FileDataSource(part.getFileName());
		    part.setDataHandler(new DataHandler(fds));
		    part.setFileName(fds.getName());
		    multipart.addBodyPart(part);
		     
		    msg.setContent(multipart);
		 
		    // 메일을 발신한다
		    Transport.send(msg);
		} catch (Exception e) {
		    // 적절히 처리
		}
	}
	
	// 여러명에게 동시에 메일발송
	public void sendMail(String fromAddr, String fromName, String toAddr[], String toName[], String title, String content){
		Properties props = System.getProperties();
		props.setProperty("mail.smtp.host", "127.0.0.1");
		Session sessions = Session.getDefaultInstance(props);
		MimeMessage msg = new MimeMessage(sessions);
		 
		try {
		    msg.setFrom(new InternetAddress(fromAddr, fromName));
		    for(int i=0; i<toAddr.length; i++){
		    	msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddr[i], toName[i]));
		    }
		    msg.setSubject(title);
		    msg.setContent(content, "text/plain; charset=utf-8");
		    Transport.send(msg);
		} catch (Exception e) {
		}
	}
}
%>

 --%>