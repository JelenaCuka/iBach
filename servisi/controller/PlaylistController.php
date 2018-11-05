<?php

class PlaylistController
{
    private $playlist;

    public function __construct($playlist)
    {
        $this->playlist = $playlist;
    }
    
    public function findAllPlaylists(){
        if ($_POST["findall"] === "1")
        {
            if($this->userIdNotEmpty() ){
                $this->playlist->setUserId($_POST["user_id"]);
                return $this->playlist->findAll();
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }
        }else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }

    }
    
    public function findOne(){
        if ($_POST["findone"] === "1")
        {
            if( $this->playlistIdNotEmpty() ){
                $this->playlist->setId( $_POST["playlist_id"] );
                return $this->playlist->findOne();
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }
        }else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }

    }
    public function findPlaylistByName(){
        if ($_POST["findname"] === "1")
        {
            if($this->userIdNotEmpty() && $this->playlistNameNotEmpty() ){
                $this->playlist->setUserId( $_POST["user_id"] );
                $this->playlist->setName( $_POST["name"] );
                if($this->playlist->userExists() ){
                    return $this->playlist->findByName();

                }else{
                    return json_encode( array("status"=>"400","description"=>"Can't get playlists for nonexistent user"));
                }
                
            }else{
                http_response_code(400);
                $row = array();
                $row["status"]= "400";
                $row["description"] = "Bad request. Missing parameters";
                return json_encode($row);
            }
        }else
        {
            http_response_code(400);
            $row = array();
            $row["status"] = "400";
            $row["description"] = "Bad request.";

            return json_encode($row);
        }

    }
    public function deletePlaylist()
    {
        if ($_POST["delete"] === "1" )
        {
            if($this->playlistIdNotEmpty ()){
                $this->playlist->setId( $_POST["playlist_id"] );
                return $this->playlist->delete();
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

    public function saveNewPlaylist()
    {
        if ($_POST["save"] === "1")
        {
            if($this->saveParametersNotEmpty()){//all needed data is prepared
                return $this->playlist->save($_POST["name"],$_POST["user_id"] );
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
    public function updatePlaylist(){
        if ($_POST["update"] === "1")
        {
            //TODO
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
        if(isset($_POST["name"]) && !empty($_POST["name"])&&
        isset($_POST["user_id"]) && !empty($_POST["user_id"]) && is_numeric($_POST["user_id"]) )
        { return true;}
        else{
            return false;
        }
    }
    public function userIdNotEmpty(){
        if(isset($_POST["user_id"]) && !empty($_POST["user_id"]) && is_numeric($_POST["user_id"]) )
        { return true;}
        else{
            return false;
        }
    }
    public function playlistNameNotEmpty (){
        if(isset($_POST["name"]) && !empty($_POST["name"]) )
        { return true;}
        else{
            return false;
        }
    }
    public function playlistIdNotEmpty (){
        if(isset($_POST["playlist_id"]) && !empty($_POST["playlist_id"]) && is_numeric($_POST["playlist_id"]) )
        { return true;}
        else{
            return false;
        }
    }
    
}

?>