<?php

class UserController
{
    private $user;

    public function __construct($user)
    {
        $this->user = $user;
    }
    public function findOne()
    {
        if ($_POST["findone"] === "1"){
            //check username and password not empty
            if($this->loginParametersNotEmpty()){//all needed data is prepared
                return $this->user->findOne();
            }elseif(isset($_POST["id"]) && !empty($_POST["id"]) && is_numeric($_POST["id"]) ){
                $id=$_POST["id"];
                return $this->user->findOneById($id);
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }

        }else{
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);

        }

    }
    public function findAllUsers()
    {
        if ($_POST["findall"] === "1"){
            return $this->user->findAll();
        }else{
            http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request.";
                return json_encode($row);
        }
        
    }
    public function saveNewUser()
    {
        if ($_POST["save"] === "1")
        {
            if($this->saveParametersNotEmpty()){//all needed data is prepared
                return $this->user->save();
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }
        }
        else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }
    }
    public function updateUser()
    {
        if ($_POST["update"] === "1")
        {
            if($this->updateParametersExist()){//all needed data is prepared
                return $this->user->update();
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }
        }
        else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }
    }
    public function deleteUser()
    {
        if ($_POST["delete"] === "1" )
        {
            if(isset($_POST["id"]) && !empty($_POST["id"]) && is_numeric($_POST["id"])){
                return $this->user->delete($_POST["id"]);
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request.";
                return json_encode($row);
                //missing id parameter or isn't numeric
            }
        }
        else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";
            return json_encode($row);
        }
    }
    public function saveParametersNotEmpty(){
        if(isset($_POST["first_name"]) && !empty($_POST["first_name"])&&
        isset($_POST["last_name"]) && !empty($_POST["last_name"])&&
        isset($_POST["email"]) && !empty($_POST["email"])&&
        isset($_POST["username"]) && !empty($_POST["username"])&&
        isset($_POST["password"]) && !empty($_POST["password"]))
        { return true;}
        else{
            return false;
        }
    }
    public function loginParametersNotEmpty(){
        if(isset($_POST["username"]) && !empty($_POST["username"])&&
        isset($_POST["password"]) && !empty($_POST["password"]) ){
            return true;
        }
        else{
            return false;
        }
    }
    public function updateParametersExist(){
        //id + at least 1 parameter to update
        if( (isset($_POST["id"]) && !empty($_POST["id"])&& is_numeric($_POST["id"]) )&&(
        isset($_POST["first_name"]) && !empty($_POST["first_name"])||
        isset($_POST["last_name"]) && !empty($_POST["last_name"])||
        isset($_POST["email"]) && !empty($_POST["email"])||
        isset($_POST["username"]) && !empty($_POST["username"])||
        isset($_POST["password"]) && !empty($_POST["password"]) ) )
        { return true;}
        else{
            return false;
        }
    }
}

?>