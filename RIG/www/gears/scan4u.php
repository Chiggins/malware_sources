<?php


function checkFile($file) {

	$file='../manage/files/hello';
	$format='json'; // json - for JSON return
	
	if (!file_exists($file)) die ("$file dosn`t exist.\n");
	
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_VERBOSE, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_URL, 'http://scan4you.net/remote.php'); //$url='http://scan4you.org/remote.php'; // Try this if .net dosn`t work
	curl_setopt($ch, CURLOPT_POST, true);
	
	$post = array('id'=>"13350",'token'=>"515fdabc0d8b3b7928c3",'action'=>'file','av_disable'=>'','av_enabled'=>'','link'=>1,'frmt'=>'json');
	
	if (class_exists('CURLFile')){
		$cfile = new CURLFile($file,'application/octet-stream','file');
		$post['uppload']=$cfile;
	} else {
		$post['uppload']='@'.$file;
	}
	
	
	
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
	$response = curl_exec($ch);
	if ($response === false || curl_errno($ch) || curl_getinfo($ch, CURLINFO_HTTP_CODE) != 200){
	    return 'ERROR:'.curl_error($ch);
	}
	
	$response = json_decode($response);
	$total = 0;
	$fired = 0;
	foreach($response as $k=>$v) {
		if ($k=='LINK') { $link = str_replace("URL=", "", $v); continue; }
		if ($response->$k!='OK') $fired++;
		$total++;
	}
	
	return array('link'=>$link,'results'=>$fired.'/'.$total);

}
?>