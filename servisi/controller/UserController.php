<?php

class UserController
{
    private $user;

    public function __construct($user)
    {
        $this->user = $user;
    }

    public function findOne($id)
    {
        if (is_numeric($id))
        {
            return $this->user->findOne($id);
        }else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }
    }

    public function findAll()
    {
        if ($_GET["findall"] === "1"){
            return $this->user->findAll();
        }else{
            http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request.";
                return json_encode($row);
        }
        
    }

    public function login()
    {
        if ($_POST["login"] === "1"&& isset($_POST["username"]) && !empty($_POST["username"])&& isset($_POST["password"]) && !empty($_POST["password"]) )
        {
            return $this->user->login($_POST["username"], $_POST["password"]);
        }
        else{
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }
    }

    public function save()
    {
        if ($_POST["save"] === "1")
        {
            if( isset($_POST["first_name"]) && !empty($_POST["first_name"])&&
            isset($_POST["last_name"]) && !empty($_POST["last_name"])&&
            isset($_POST["email"]) && !empty($_POST["email"])&&
            isset($_POST["username"]) && !empty($_POST["username"])&&
            isset($_POST["password"]) && !empty($_POST["password"])  ){
                return $this->user->save($_POST["username"],$_POST["password"],$_POST["email"],$_POST["first_name"],$_POST["last_name"]);
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

    public function update()
    {
        if ($_POST["update"] === "1")
        {
            if( isset($_POST["id"]) && !empty($_POST["id"])&& is_numeric($_POST["id"]) &&
            isset($_POST["first_name"]) && !empty($_POST["first_name"])&&
            isset($_POST["last_name"]) && !empty($_POST["last_name"])&&
            isset($_POST["password"]) && !empty($_POST["password"]) ){
                return $this->user->update($_POST["id"],$_POST["first_name"],$_POST["last_name"],$_POST["password"]);
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
    public function delete()
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
}

?>