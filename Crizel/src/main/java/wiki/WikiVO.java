package wiki;

import org.springframework.stereotype.Repository;

@Repository("wikiVO")
public class WikiVO {
	private int wiki_id;
	private String wiki_title;
	private String wiki_content;
	private int wiki_cate_id;
	private String wiki_cate_val;
	public int getWiki_id() {
		return wiki_id;
	}
	public void setWiki_id(int wiki_id) {
		this.wiki_id = wiki_id;
	}
	public String getWiki_title() {
		return wiki_title;
	}
	public void setWiki_title(String wiki_title) {
		this.wiki_title = wiki_title;
	}
	public String getWiki_content() {
		return wiki_content;
	}
	public void setWiki_content(String wiki_content) {
		this.wiki_content = wiki_content;
	}
	public int getWiki_cate_id() {
		return wiki_cate_id;
	}
	public void setWiki_cate_id(int wiki_cate_id) {
		this.wiki_cate_id = wiki_cate_id;
	}
	public String getWiki_cate_val() {
		return wiki_cate_val;
	}
	public void setWiki_cate_val(String wiki_cate_val) {
		this.wiki_cate_val = wiki_cate_val;
	}
	
	
	
	
	
	
}
