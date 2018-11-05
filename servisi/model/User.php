<?php

class User
{
    private $id;
    private $username;
    private $password;
    private $email;
    private $firstName;
    private $lastName;
    private $timeModified;
    private $timeDeleted;
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }
    public function findOne()
    {
        $this->username = $_POST["username"];
        $this->password = $_POST["password"]; 
        $stmt = $this->db->prepare("SELECT id, first_name, last_name, email, deleted_at, modified_at, username, password FROM user WHERE username = ? and deleted_at is null");
        $stmt->bind_param("s", $this->username);
        $stmt->execute();

        $result = $stmt->get_result();
        $r = $result->fetch_assoc();
        if(!empty($r)){
            if($this->passwordIsCorrect($r["password"])){
                $userArray=array();
                $userArray["info"]=array("status"=>"200","description"=>"Login success.");
                $userArray["user"]=$r;
                return json_encode($userArray);
            }else{
                return json_encode( array("status"=>"404","description"=>"Not found. Login Unsuccessful."));
            }
        }else{
            return json_encode( array("status"=>"404","description"=>"Not found. Login Unsuccessful."));
        }
    }
    public function findOneById($id){
        $this->id=$id;
        $stmt = $this->db->prepare("SELECT id, first_name, last_name, email, deleted_at, modified_at, username, password FROM user WHERE id = ? and deleted_at is null");
        $stmt->bind_param("i", $this->id);
        $stmt->execute();

        $result = $stmt->get_result();
        $r = $result->fetch_assoc();
        if(!empty($r)){
                $userArray=array();
                $userArray["info"]=array("status"=>"200","description"=>"User found.");
                $userArray["user"]=$r;
                return json_encode($userArray);
        }else{
            return json_encode( array("status"=>"404","description"=>"Not found. There is no user with that id."));
        }


    }
    public function findAll()
    {
        $stmt = $this->db->prepare("SELECT id, first_name, last_name, email, deleted_at, modified_at, username, password FROM user");
        $stmt->execute();
        
        $result = $stmt->get_result();
        $userList = array();

        while ($r = $result->fetch_object())
        {
            array_push($userList, $r);
        }
        if(!empty($userList)){
            return json_encode($userList);
        }else{
            return json_encode( array("status"=>"200","description"=>"Table users has no entries"));
        }
    }
    public function save()
    {
        $this->username = $_POST["username"];
        $this->password = password_hash($_POST["password"], PASSWORD_DEFAULT); //crypt password
        $this->email = $_POST["email"];
        $this->firstName = $_POST["first_name"];
        $this->lastName = $_POST["last_name"];

        if($this->usernameIsNotDuplicate()&&$this->emailIsNotDuplicate()){
            if($this->saveUserToDatabase()){
                $row = array();
                $row["status"]= "200";
                $row["description"] = "User successfully created.";
                return json_encode($row);
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Unexpected error while creating user.";
                return json_encode($row);
            }
        }else{
            if(!$this->usernameIsNotDuplicate()&&!$this->emailIsNotDuplicate()){
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Username and email already exist.";
                return json_encode($row);

            }elseif(!$this->emailIsNotDuplicate()){
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "There's account with that email.";
                return json_encode($row);
            }
            elseif(!$this->usernameIsNotDuplicate()){
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "That username is already taken.";
                return json_encode($row);
            }
        }
    
    }
    public function update()
    {
        $noDuplicatesToUpdate=true;
        $errorlog="";
        if( isset($_POST["email"]) && !empty($_POST["email"]) ){
            $this->email = $_POST["email"];
            if(!$this->emailIsNotDuplicate()){
                $noDuplicatesToUpdate=false;
                $errorlog.=" Email is already taken. Can't update.";
            }
        }
        if( isset($_POST["username"]) && !empty($_POST["username"]) ){
            $this->username = $_POST["username"];
            if(!$this->usernameIsNotDuplicate()){
                $noDuplicatesToUpdate=false;
                $errorlog.=" Username is already taken. Can't update.";
            }
        }
        if($noDuplicatesToUpdate){
            if($this->updateUser() ){
                $stmt = $this->db->prepare("SELECT id, first_name, last_name, email, deleted_at, modified_at, username, password FROM user WHERE id = ? and deleted_at is null");
                $stmt->bind_param("s", $this->id);
                $stmt->execute();

                $result = $stmt->get_result();
                $r = $result->fetch_assoc();
                if(!empty($r)){
                        $userArray=array();
                        $userArray["info"]=array("status"=>"200","description"=>"User successfully updated.");
                        $userArray["user"]=$r;
                        return json_encode($userArray);
                }else{
                    return json_encode( array("status"=>"404","description"=>"Not found. Unknown update error."));
                }
            }else{
                $row = array();
                $row["status"]= "400";
                $row["description"] = "User not updated.";
                return json_encode($row);
            }
        }else{
            return json_encode( array("status"=>"400","description"=>$errorlog));
        }
        
    }
    public function delete($id)
    {
        $this->id = $id;

        $stmt = $this->db->prepare("UPDATE user SET deleted_at = CURRENT_TIMESTAMP WHERE id = ? and deleted_at is null");
        $stmt->bind_param("i", $this->id);
        $stmt->execute();

        if ($stmt->affected_rows === 1)
        {
            $row = array();
            $row["status"]= "200";
            $row["description"] = "OK. User deleted";
            $stmt->close();

            return json_encode($row);

        }elseif($stmt->affected_rows === 0){
            $stmt = $this->db->prepare("SELECT id FROM user where id=?");
            $stmt->bind_param("i", $this->id);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows === 1){
                $row = array();
                $row["status"]= "200";
                $row["description"] = "0 users deleted";
                $stmt->close();
                
                return json_encode($row);
                //ex:User exists but maybe is already deleted or something else

            }else{
                $row = array();
                $row["status"]= "400";
                $row["description"] = " Bad request.";
                $stmt->close();

                return json_encode($row);
                //ex:ID is properly formated (integer)but there's no user with that id
            }
        }
        else
        {
            http_response_code(500);
            $row = array();
            $row["status"] = "500";
            $row["description"] = "Internal server error. 0 rows affected";
            $stmt->close();

            return json_encode($row);
        }
    }
    
    public function usernameIsNotDuplicate(){
        //both active and deactivated accounts are considered
        $stmt = $this->db->prepare("SELECT COUNT(id) FROM user WHERE username=?");
        $stmt->bind_param("s",$this->username);
        $stmt->execute();

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $stmt->close();
        if($row["COUNT(id)"]>=1){
            return false;

        }else{
            return true;
        }
    }
    public function emailIsNotDuplicate(){
        //only active are considered
        $stmt = $this->db->prepare("SELECT COUNT(id) FROM user WHERE email=? and deleted_at is null");
        $stmt->bind_param("s", $this->email);
        $stmt->execute();

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $stmt->close();
        if($row["COUNT(id)"]>=1){
            return false;

        }else{
            return true;
        }
    }
    public function saveUserToDatabase(){
        $stmt = $this->db->prepare("INSERT INTO user (first_name, last_name, email, deleted_at,modified_at,username,password) VALUES (?,?,?,null,now(),?,?)");
        $stmt->bind_param("sssss", $this->firstName, $this->lastName, $this->email, $this->username, $this->password);
        $stmt->execute();

        if ($stmt->affected_rows === 1)
        {
            $stmt->close();
            return true;
        }
        else
        {
            $stmt->close();
            return false;
        }
    }
    public function passwordIsCorrect($hash){
        if(password_verify($this->password,$hash)){
            return true;
        }else{
            return false;
        }
    }
    public function prepareUpdateValues(){
        $bindArray=array();
        $bindArray["bindType"]="i";//id is integer//add values to begining
        $bindArray["bindValuesArray"]=array();
        $bindArray["queryStart"]="update user set ";
        $bindArray["queryEnd"]=" where id=?";
        $bindArray["queryMiddle"]="";
        $bindArray["queryFilnal"]="";
        $bindArray["firstValueAdded"]=false;
        $this->id=$_POST["id"];

        if(isset($_POST["first_name"]) && !empty($_POST["first_name"])){
            $this->firstName = $_POST["first_name"];
            $bindArray=$this->prepareBindParameters($bindArray,"first_name",$this->firstName,"s");
        }
        if(isset($_POST["last_name"]) && !empty($_POST["last_name"])){
            $this->lastName = $_POST["last_name"];
            $bindArray=$this->prepareBindParameters($bindArray,"last_name",$this->lastName,"s");
        }
        if(isset($_POST["email"]) && !empty($_POST["email"])){
            $this->email = $_POST["email"];
            $bindArray=$this->prepareBindParameters($bindArray,"email",$this->email,"s");
        }
        if(isset($_POST["username"]) && !empty($_POST["username"])){
            $this->username = $_POST["username"];
            $bindArray=$this->prepareBindParameters($bindArray,"username",$this->username,"s");
        }
        if(isset($_POST["password"]) && !empty($_POST["password"])){
            $this->password = password_hash($_POST["password"], PASSWORD_DEFAULT);
            $bindArray=$this->prepareBindParameters($bindArray,"password",$this->password,"s");
        }
        $bindArray["queryFilnal"]=$bindArray["queryStart"].$bindArray["queryMiddle"].$bindArray["queryEnd"];
        array_push($bindArray["bindValuesArray"],$this->id);
        return $bindArray;

    }
    public function prepareBindParameters($arr,$name,$value,$type){
        if($arr["firstValueAdded"]){
            $arr["queryMiddle"].=" ,".$name."=? "; //comma
            array_push($arr["bindValuesArray"],$value);
            $arr["bindType"]=$type.$arr["bindType"];
        }else{
            $arr["queryMiddle"].=" ".$name."=? "; //first column updated in a row doesn't need comma before its column name
            array_push($arr["bindValuesArray"],$value);
            $arr["bindType"]=$type.$arr["bindType"];
            $arr["firstValueAdded"]=true;
        }
        return $arr;
    }
    public function updateUser(){
        $bindArray=$this->prepareUpdateValues();
        $stmt = $this->db->prepare($bindArray["queryFilnal"]);
        $stmt->bind_param($bindArray["bindType"],...$bindArray["bindValuesArray"]);//...argument unpacking
        $stmt->execute();

        if ($stmt->affected_rows === 1)
        {
            $stmt->close();
            return true;
        }
        else
        {
            $stmt->close();
            return false;
        }
    }

}

?>