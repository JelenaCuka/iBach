<?php

header('Content-type: application/json');

require_once "../../config/database.php";
require_once "../../model/User.php";
require_once "../../controller/UserController.php";

if (isset($_POST["findall"]) && !empty($_POST["findall"])){
    //database connection
    $db = connect();

    //model and controller calls
    $user = new User($db);
    $userController = new UserController($user);

    //controller function to push the right data
    print $userController->findAllUsers();
}
?>