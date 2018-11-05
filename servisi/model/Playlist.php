<?php
class Playlist
{
    private $id;
    private $name;
    private $userId;
    private $modified_at;
    private $deleted_at;
    private $db;



    public function __construct($db)
    {
        $this->db = $db;
    }
    public function setId($ID) {
        $this->id = $ID;
    }
    public function setName($name) {
        $this->name = $name;
    }
    public function setUserId($userId) {
        $this->userId = $userId;
    }
    public function setModifiedAt($modified_at) {
        $this->modified_at = $modified_at;
    }
    public function setDeletedAt($deleted_at) {
        $this->deleted_at = $deleted_at;
    }
      
    public function getId() {
        return $this->id;
    }
    public function getName() {
        return $this->name;
    }
    public function getUserId() {
        return $this->userId;
    }
    public function getModifiedAt() {
        return $this->modified_at;
    }
    public function getDeletedAt() {
        return $this->deleted_at;
    }
    public function findAll(){
        if($this->userExists() ){
            $stmt = $this->db->prepare("SELECT id, name, user_id, modified_at FROM playlist where user_id=? and deleted_at is null");
            $stmt->bind_param("i", $this->userId );
            $stmt->execute();
            
            $result = $stmt->get_result();
            $playList = array();

            while ($r = $result->fetch_object())
            {
                array_push($playList, $r);
            }
            if(!empty($playList)){
                return json_encode($playList);
            }else{
                return json_encode( array("status"=>"200","description"=>"User has 0 playlists"));
            }
        }else{
            return json_encode( array("status"=>"200","description"=>"Can't get playlists for nonexistent user"));
        }
    }
    

    public function findOne(){
        $stmt = $this->db->prepare("SELECT id, name, user_id, modified_at FROM playlist where id=? and deleted_at is null");

        $stmt->bind_param("i", $this->id);
        $stmt->execute();
            
        $result = $stmt->get_result();
        $r = $result->fetch_assoc();
        if(!empty($r)){
            $playlist=array();
            $playlist["info"]=array("status"=>"200","description"=>"Playlist found.");
            $playlist["playlist"]=$r;
            return json_encode($playlist);
        }else{
            return json_encode( array("status"=>"200","description"=>"Playlist not found."));
        }
        
    }
    public function findByName(){
        $stmt = $this->db->prepare("SELECT id, name, user_id, modified_at FROM playlist where user_id=? and name LIKE concat('%', ?, '%') and deleted_at is null");
        $stmt->bind_param("is", $this->userId,$this->name);
        $stmt->execute();
            
        $result = $stmt->get_result();
        $playList = array();

        while ($r = $result->fetch_object())
        {
            array_push($playList, $r);
        }
        if(!empty($playList)){
            return json_encode($playList);
        }else{
            return json_encode( array("status"=>"200","description"=>"Playlist not found"));
        }
        
    }
    public function delete()
    {
        //dodati if playlist exists
        $stmt = $this->db->prepare("UPDATE playlist SET deleted_at = CURRENT_TIMESTAMP WHERE id = ? and deleted_at is null");
        $stmt->bind_param("i", $this->id);
        $stmt->execute();

        if ($stmt->affected_rows === 1)
        {
            
            $row = array();
            $row["status"]= "200";
            $row["description"] = "OK. Playlist deleted";
            $stmt->close();
            return json_encode($row);

        }else{
            $row = array();
            $row["status"]= "400";
            $row["description"] = " Bad request. Playlist doesn't exists.";
            $stmt->close();
            return json_encode($row);
        }
    }
    public function save($name,$user_id){
        $this->setName($name);
        $this->setUserId($user_id);

        if($this->playlistExists() ){
            return json_encode( array("status"=>"400","description"=>"Playlist with that name already exists"));
        }else{
            if($this->userExists() ){
                if($this->savePlaylistToDatabase() ){
                    $playlistArray=array();
                    $playlistArray["info"]=array("status"=>"200","description"=>"Playlist saved.");
                    $playlistArray["playlist"]=$this->findPlaylistByNameAndUser();
                    return json_encode($playlistArray);
                }else{
                    return json_encode( array("status"=>"400","description"=>"Uknnown error while creating playlist."));
                }
            }else{
                return json_encode( array("status"=>"400","description"=>"Can't create playlist for user who doesn't exist."));
            }
        }
    }
    public function savePlaylistToDatabase(){
        $stmt = $this->db->prepare("INSERT INTO playlist (name, user_id, modified_at, deleted_at) VALUES (?,?,now(),null)");
        $stmt->bind_param("si", $this->name, $this->userId );
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
    public function playlistExists(){
        $stmt = $this->db->prepare("SELECT COUNT(id) FROM playlist WHERE name=? and user_id=? and deleted_at is null");
        $stmt->bind_param("si", $this->name, $this->userId );
        $stmt->execute();

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $stmt->close();
        if($row["COUNT(id)"]>=1){
            return true;

        }else{
            return false;
        }
    }
    public function userExists(){
        $stmt = $this->db->prepare("SELECT COUNT(id) FROM user WHERE id=? and deleted_at is null");
        $stmt->bind_param("i",$this->userId );
        $stmt->execute();

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $stmt->close();
        if($row["COUNT(id)"]>=1){
            return true;

        }else{
            return false;
        }
    }
    public function findPlaylistByNameAndUser(){
        $stmt = $this->db->prepare("SELECT id,name,user_id,modified_at,deleted_at FROM playlist WHERE name=? and user_id=? and deleted_at is null");
        $stmt->bind_param("si", $this->name, $this->userId );
        $stmt->execute();

        $result = $stmt->get_result();
        $r = $result->fetch_assoc();
        $stmt->close();
        if(!empty($r)){
            return $r;
        }else{
            return null;
        }
    }


}

?>