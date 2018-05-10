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
String fromAddr		= request.getParameter("fromAddr")==null?"":request.getParameter("fromAddr");
String fromName		= request.getParameter("fromName")==null?"":request.getParameter("fromName");
String toAddr		= request.getParameter("toAddr")==null?"":request.getParameter("toAddr");
String toName		= request.getParameter("toName")==null?"":request.getParameter("toName");
String title		= request.getParameter("title")==null?"":request.getParameter("title");
String content		= request.getParameter("content")==null?"":request.getParameter("content");

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
Session session2 = Session.getDefaultInstance(props);
MimeMessage msg = new MimeMessage(session2);
 
try {
    // 발신자, 수신자, 참조자, 제목, 본문 내용 등을 설정한다
    msg.setFrom(new InternetAddress("ksh@mail.k-sis.com", "테스트메일"));
    msg.addRecipient(Message.RecipientType.TO, new InternetAddress("rhzhzh3@naver.com", "고성훈"));
    //msg.addRecipient(Message.RecipientType.TO, new InternetAddress("eee@fff.co.kr", "선덕여왕"));
    //msg.addRecipient(Message.RecipientType.CC, new InternetAddress("ggg@hhh.co.kr", "의자왕"));
    msg.setSubject("제목이 이러저러합니다");
    //msg.setContent("본문이 어쩌구저쩌구합니다", "text/html; charset=utf-8");
    msg.setContent("본문이 어쩌구저쩌구합니다", "text/plain; charset=utf-8");
 
    // 메일을 발신한다
    Transport.send(msg);
    out.println("TEST");
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