<?php

require "conn.php";

if($_SERVER['REQUEST_METHOD'] == "POST"){
    $response = array();
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    $cek = "SELECT * FROM tb_user WHERE nama='$username' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($connect, $cek));

    if(isset($result)){
        // $response['value'] = 1;
        $response['message'] = 'Login Berhasil';
        echo json_encode($response);

    } else{
            // $response['value'] = 0;
            $response['message'] = "login gagal";
            echo json_encode($response);
        }
    }

?>