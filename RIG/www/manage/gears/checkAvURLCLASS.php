<?php

class checkURL {

	private $s4y_id = "13350";
	private $s4y_token = "515fdabc0d8b3b7928c3";
	
	function s4t_check($link){
		$url=$this->s4t_get_url();
		if(!$url) return 'ERROR:cant get s4y url';
		if($url == 'FAIL') return 'ERROR:cant get s4y url';
		$type='domain'; $format='txt';
		$post=array('id'=>$this->s4y_id,'token'=>$this->s4y_token,'action'=>$type);
		$post['av_disable']='';
		$post['av_enabled']='';
		$post[$type]=$link;
		$c=curl_init();
		curl_setopt_array($c,array(CURLOPT_HEADER=>0,CURLOPT_VERBOSE=>0,CURLOPT_RETURNTRANSFER=>true,CURLOPT_URL=>$url,CURLOPT_TIMEOUT=>35,CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>$post));
		$r = curl_exec($c);
		if($r===false) return 'ERROR:'.curl_error($c);
		if(curl_getinfo($c,CURLINFO_HTTP_CODE) != 200) return 'ERROR:'.curl_error($c);
		return $r;
	}
	
	// проверка Check серверов на доступность
	function s4t_get_url(){
		$us = array(
			'scan4you.net',
			'scan4you.org',
			'85.31.101.187',
			'85.31.101.148'
		);
		foreach ($us as $v){
			$c=curl_init();
			curl_setopt_array($c,array(CURLOPT_HEADER=>0,CURLOPT_VERBOSE=>0,CURLOPT_RETURNTRANSFER=>true, CURLOPT_URL=>"http://$v/z325.txt",CURLOPT_TIMEOUT,5));
			$r=curl_exec($c);
			curl_close($c);
			if($r=='qga34'){
				return "http://".$v."/remote.php";
			}
		}
		die("can`t find s4y server");
	}
	
	function is_ok($o){
		$o=trim($o);
		if(!$o) return array('msg'=>'Error in is_ok with $o', 'full'=>'');
		$r=$this->s4t_check($o);
		$res = explode("\n",$r);
		//print_r($res);
		if (count($res)>3) {
			$t = 0;
			$f = 0;
			foreach($res as $k=>$v) {
				if ($v == '') continue;
				$a = explode(':',$v);
				//print_r($a);
				if($a=='ERROR') exit(json_encode(array('type'=>'error','msg'=>$v,'proxy_id'=>$_POST['proxyURL'])));
				if($a[1]!='OK')$f++;
				$t++;
			}
		} else return array('msg'=>$r, 'full'=>'');
		return array('inBan'=>$f, 'msg'=>'('.$f.'/'.$t.')', 'full'=>$r);
	}

}

?>