<?php

$connect = new mysqli("10.10.10.102","root","","flutter");
$connect2 = new mysqli("192.168.0.2","intern","intern@ptmdr","themomi");

if($connect2){
    
}else{
	echo "Connection Failed";
	exit();
}