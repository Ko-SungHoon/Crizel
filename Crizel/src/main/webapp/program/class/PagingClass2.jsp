<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
public class Paging2 {
    private int pageSize; // 게시 글 수
    private int pageBlock;
    private int firstPageNo; // 첫 번째 페이지 번호
    private int prevPageNo; // 이전 페이지 번호
    private int startPageNo; // 시작 페이지 (페이징 네비 기준)
    private int prevStartPageNo;
    private int pageNo2; // 페이지 번호
    private int endPageNo; // 끝 페이지 (페이징 네비 기준)
    private int nextEndPageNo;
    private int nextPageNo; // 다음 페이지 번호
    private int finalPageNo; // 마지막 페이지 번호
    private int totalCount; // 게시 글 전체 수
    private int startRowNo;
    private int endRowNo;
    private int rowNo;
    
    private StringBuffer params = new StringBuffer();

    /**
     * @return the pageSize
     */
    public int getPageSize() {
        return pageSize;
    }

    /**
     * @param pageSize the pageSize to set
     */
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    
    /**
     * @return the pageBlock
     */
    public int getPageBlock() {
        return pageBlock;
    }

    /**
     * @param pageBlock the pageBlock to set
     */
    public void setPageBlock(int pageBlock) {
        this.pageBlock = pageBlock;
    }

    /**
     * @return the firstPageNo
     */
    public int getFirstPageNo() {
        return firstPageNo;
    }

    /**
     * @param firstPageNo the firstPageNo to set
     */
    public void setFirstPageNo(int firstPageNo) {
        this.firstPageNo = firstPageNo;
    }

    /**
     * @return the prevPageNo
     */
    public int getPrevPageNo() {
        return prevPageNo;
    }

    /**
     * @param prevPageNo the prevPageNo to set
     */
    public void setPrevPageNo(int prevPageNo) {
        this.prevPageNo = prevPageNo;
    }
    
    /**
     * @return the prevStartPageNo
     */
    public int getPrevStartPageNo() {
        return prevStartPageNo;
    }

    /**
     * @param prevStartPageNo the prevStartPageNo to set
     */
    public void setPrevStartPageNo(int prevStartPageNo) {
        this.prevStartPageNo = prevStartPageNo;
    }

    /**
     * @return the startPageNo
     */
    public int getStartPageNo() {
        return startPageNo;
    }

    /**
     * @param startPageNo the startPageNo to set
     */
    public void setStartPageNo(int startPageNo) {
        this.startPageNo = startPageNo;
    }

    /**
     * @return the pageNo
     */
    public int getPageNo() {
        return pageNo2;
    }

    /**
     * @param pageNo the pageNo to set
     */
    public void setPageNo(int pageNo2) {
        this.pageNo2 = pageNo2;
    }

    /**
     * @return the endPageNo
     */
    public int getEndPageNo() {
        return endPageNo;
    }

    /**
     * @param endPageNo the endPageNo to set
     */
    public void setEndPageNo(int endPageNo) {
        this.endPageNo = endPageNo;
    }

    /**
     * @return the nextPageNo
     */
    public int getNextPageNo() {
        return nextPageNo;
    }

    /**
     * @param nextPageNo the nextPageNo to set
     */
    public void setNextPageNo(int nextPageNo) {
        this.nextPageNo = nextPageNo;
    }
    
    /**
     * @return the nextPageNo
     */
    public int getNextEndPageNo() {
        return nextEndPageNo;
    }

    /**
     * @param nextPageNo the nextPageNo to set
     */
    public void setNextEndPageNo(int nextEndPageNo) {
        this.nextEndPageNo = nextEndPageNo;
    }

    /**
     * @return the finalPageNo
     */
    public int getFinalPageNo() {
        return finalPageNo;
    }

    /**
     * @param finalPageNo the finalPageNo to set
     */
    public void setFinalPageNo(int finalPageNo) {
        this.finalPageNo = finalPageNo;
    }

    /**
     * @return the totalCount
     */
    public int getTotalCount() {
        return totalCount;
    }

    /**
     * @param totalCount the totalCount to set
     */
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        this.makePaging();
    }
    
    /**
     * @return the startRowNo
     */
    public int getStartRowNo() {
        return startRowNo;
    }

    /**
     * @param startRowNo the startRowNo to set
     */
    public void setStartRowNo(int startRowNo) {
        this.startRowNo = startRowNo;
    }
    
    /**
     * @return the startRowNo
     */
    public int getEndRowNo() {
        return endRowNo;
    }

    /**
     * @param startRowNo the startRowNo to set
     */
    public void setEndRowNo(int endRowNo) {
        this.endRowNo = endRowNo;
    }
    
    /**
     * @return the startRowNo
     */
    public int getRowNo() {
        return rowNo;
    }

    /**
     * @param startRowNo the startRowNo to set
     */
    public void setRowNo(int rowNo) {
        this.rowNo = rowNo;
    }
    
    public void setParams(String key, String value) {
    	if(key != null && value != null && !"".equals(key)) {
    		this.params.append("<input type=\"hidden\" name=\"");
    		this.params.append(key);
    		this.params.append("\" value=\"");
    		this.params.append(value);
    		this.params.append("\" /> \n");
    	}
    }
    
    public void setParams2(String key, String value[]) {
    	if(key != null && value.length>0 && !"".equals(key)) {
    		for(int i=0; i<value.length; i++){
    			this.params.append("<input type=\"checkbox\" name=\"");
        		this.params.append(key);
        		this.params.append("\" value=\"");
        		this.params.append(value[i]);
        		this.params.append("\" style=\"display:none\" /> \n");
    		}
    	}
    }
    
    public String getParams() {
    	return this.params.toString();
    }

    /**
     * 페이징 생성
     */
    private void makePaging() {
        if (this.totalCount == 0) return; // 게시 글 전체 수가 없는 경우
        if (this.pageNo2 == 0) this.setPageNo(1); // 기본 값 설정
        if (this.pageSize == 0) this.setPageSize(10); // 기본 값 설정
        if (this.pageBlock == 0) this.setPageBlock(10); // 기본 값 설정

        int finalPage = (totalCount + (pageSize - 1)) / pageSize; // 마지막 페이지
        if (this.pageNo2 > finalPage) this.setPageNo(finalPage); // 기본 값 설정

        if (this.pageNo2 < 0 || this.pageNo2 > finalPage) this.pageNo2 = 1; // 현재 페이지 유효성 체크

        boolean isNowFirst = pageNo2 == 1 ? true : false; // 시작 페이지 (전체)
        boolean isNowFinal = pageNo2 == finalPage ? true : false; // 마지막 페이지 (전체)

        int startPage = ((pageNo2 - 1) / this.pageBlock) * this.pageBlock + 1; // 시작 페이지 (페이징 네비 기준)
        int endPage = startPage + this.pageBlock - 1; // 끝 페이지 (페이징 네비 기준)

        if (endPage > finalPage) { // [마지막 페이지 (페이징 네비 기준) > 마지막 페이지] 보다 큰 경우
            endPage = finalPage;
        }

        this.setFirstPageNo(1); // 첫 번째 페이지 번호

        if (isNowFirst) {
            this.setPrevPageNo(1); // 이전 페이지 번호
        } else {
            this.setPrevPageNo(((pageNo2 - 1) < 1 ? 1 : (pageNo2 - 1))); // 이전 페이지 번호
        }

        this.setStartPageNo(startPage); // 시작 페이지 (페이징 네비 기준)
        this.setEndPageNo(endPage); // 끝 페이지 (페이징 네비 기준)

        if (isNowFinal) {
            this.setNextPageNo(finalPage); // 다음 페이지 번호
        } else {
            this.setNextPageNo(((pageNo2 + 1) > finalPage ? finalPage : (pageNo2 + 1))); // 다음 페이지 번호
        }
        
        if(startPage > 1) this.setPrevStartPageNo(startPage - 1);
        else this.setPrevStartPageNo(1);
        if(endPage < finalPage) this.setNextEndPageNo(endPage + 1);
        else this.setNextEndPageNo(finalPage);

        this.setFinalPageNo(finalPage); // 마지막 페이지 번호
        
        this.setStartRowNo((pageNo2-1) * pageSize);
        this.setEndRowNo(pageNo2 * pageSize);
        this.setRowNo(totalCount - ((pageNo2-1) * pageSize));
    }
    
    public String getHtml(String mode) {
    	if(mode == null) mode = "1";
    	
    	StringBuffer html = new StringBuffer();
    	
    	html.append("<a class='bt' href=\"javascript:;\" onclick=\"goPage2(");
    	html.append(Integer.toString(this.firstPageNo));
    	html.append("); return false;\">");
    	if("2".equals(mode)) html.append("&lt;&lt;");
    	else html.append("처음");
    	html.append("</a>");
    	//if("2".equals(mode)) html.append("&nbsp;");
    	if("1".equals(mode)) html.append("&#160;");
    	html.append("<a class='bt' href=\"javascript:;\" onclick=\"goPage2(");
    	html.append(Integer.toString(this.prevStartPageNo));
    	html.append("); return false;\">");
    	if("2".equals(mode)) html.append("&lt;");
    	else html.append("이전");
    	html.append("</a>");
    	if("1".equals(mode)) html.append("&#160;");
    	
    	for(int i=this.startPageNo; i<=this.endPageNo; i++) {
    		if(i == this.pageNo2) {
    			if("2".equals(mode)) {
    				html.append("<a href=\"javascript:;\" class=\"on\" onclick=\"goPage2(");
        			html.append(Integer.toString(i));
        			html.append("); return false;\">");
        			html.append(Integer.toString(i));
        			html.append("</a>");
    			} else {
    				html.append("<strong>");
        			html.append(Integer.toString(i));
        			html.append("</strong>");
    			}
    		} else {
    			html.append("<a href=\"javascript:;\" onclick=\"goPage2(");
            	html.append(Integer.toString(i));
            	html.append("); return false;\">");
            	html.append(Integer.toString(i));
            	html.append("</a>");
    		}
    		if("1".equals(mode)) html.append("&#160;");
    	}
    	
    	html.append("<a class='bt' href=\"javascript:;\" onclick=\"goPage2(");
    	html.append(Integer.toString(this.nextEndPageNo));
    	html.append("); return false;\">");
    	if("2".equals(mode)) html.append("&gt;");
    	else html.append("다음");
    	html.append("</a>");
    	if("1".equals(mode)) html.append("&#160;");
    	html.append("<a class='bt' href=\"javascript:;\" onclick=\"goPage2(");
    	html.append(Integer.toString(this.finalPageNo));
    	html.append("); return false;\">");
    	if("2".equals(mode)) html.append("&gt;&gt;");
    	else html.append("마지막");
    	html.append("</a>");
    	if("1".equals(mode)) html.append("&#160;");
    	
    	html.append(" \n");
    	
    	html.append("<form action=\"\" method=\"post\" id=\"pagingForm2\" name=\"pagingForm2\">");
    	html.append("<input type=\"hidden\" name=\"pageNo2\" value=\"\">");
    	html.append(this.getParams());
    	html.append("</form> \n");
    	
    	html.append("<script type=\"text/javascript\"> \n");
    	html.append("function goPage2(page) { \n");
    	html.append("	document.pagingForm2.pageNo2.value = page; \n");
    	html.append("	document.pagingForm2.submit(); \n");
    	html.append("} \n");
    	html.append("</script> \n");
    	
    	return html.toString();
    }
    
    public String getHtml() {
    	String mode = "1";
    	return getHtml(mode);
    }

}
%>