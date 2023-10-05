<?php
include 'conn.php';

$queryResult=$connect->query("SELECT * FROM sensors ORDER BY updated_at DESC LIMIT 24");

$result=array();

while($fetchData=$queryResult->fetch_assoc()){
	$result[]=$fetchData;
}

echo json_encode($result);

?>
