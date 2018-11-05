<?php

function connect()
{
    $host = "localhost";
    $username = "ibachuser";
    $password = "1airDB1";
    $database = "mydb";

    return new MySqli($host, $username, $password, $database);
}

?>