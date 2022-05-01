function getPage(page){
	try{
		$(".contentWrap").load('./html/' + page + '.html');
	}catch{
		console.log('err');
	}
	
}