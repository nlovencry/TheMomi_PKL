<?php

	include 'conn.php';
	
	$nama = $_POST['nama'];
	$password = $_POST['password'];
	$alamat = $_POST['alamat'];
	$jk= $_POST['jk'];
    $agama= $_POST['agama'];
	
    $result = mysqli_query($connect,"insert into tb_user set nama='$nama', password='$password', alamat='$alamat', jk='$jk', agama='$agama' ");
    if($connect){
        echo json_encode([
            'message' => 'Data input successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to input'
        ]);
    }

?>