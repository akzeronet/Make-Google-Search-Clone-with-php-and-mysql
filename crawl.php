<?php
include("includes/config.php");
include("includes/DomDocumentParser.php");

$alreadyCrawled = array();
$crawling = array();
$alreadyFoundImages = array();

function linkExists($url) {
    global $db;

    $query = $db->prepare("SELECT * FROM sites WHERE url = :url");

    $query->bindParam(":url", $url);
    $query->execute();

    return $query->rowCount() != 0;
}

function insertLink($url, $title, $description, $keywords) {
    global $db;

    $query = $db->prepare("INSERT INTO sites(url, title, description, keywords)
                            VALUES(:url, :title, :description, :keywords)");

    $query->bindParam(":url", $url);
    $query->bindParam(":title", $title);
    $query->bindParam(":description", $description);
    $query->bindParam(":keywords", $keywords);

    return $query->execute();
}

function insertImage($url, $src, $alt, $title) {
    global $db;

    $query = $db->prepare("INSERT INTO images(siteUrl, imageUrl, alt, title)
                            VALUES(:siteUrl, :imageUrl, :alt, :title)");

    $query->bindParam(":siteUrl", $url);
    $query->bindParam(":imageUrl", $src);
    $query->bindParam(":alt", $alt);
    $query->bindParam(":title", $title);

    return $query->execute();
}

function insertVideo($url, $title, $thumbnailUrl) {
    global $db;

    $query = $db->prepare("INSERT INTO videos(videoUrl, title, thumbnailUrl)
                            VALUES(:videoUrl, :title, :thumbnailUrl)");

    $query->bindParam(":videoUrl", $url);
    $query->bindParam(":title", $title);
    $query->bindParam(":thumbnailUrl", $thumbnailUrl);

    return $query->execute();
}

function createLink($src, $url) {

    $scheme = parse_url($url)["scheme"]; // http
    $host = parse_url($url)["host"]; // www.example.com
    
    if(substr($src, 0, 2) == "//") {
        $src =  $scheme . ":" . $src;
    }
    else if(substr($src, 0, 1) == "/") {
        $src = $scheme . "://" . $host . $src;
    }
    else if(substr($src, 0, 2) == "./") {
        $src = $scheme . "://" . $host . dirname(parse_url($url)["path"]) . substr($src, 1);
    }
    else if(substr($src, 0, 3) == "../") {
        $src = $scheme . "://" . $host . "/" . $src;
    }
    else if(substr($src, 0, 5) != "https" && substr($src, 0, 4) != "http") {
        $src = $scheme . "://" . $host . "/" . $src;
    }

    return $src;
}

function getDetails($url) {

    global $alreadyFoundImages;

    $parser = new DomDocumentParser($url);

    $titleArray = $parser->getTitleTags();

    if(sizeof($titleArray) == 0 || $titleArray->item(0) == NULL) {
        return;
    }

    $title = $titleArray->item(0)->nodeValue;
    $title = str_replace("\n", "", $title);

    if($title == "") {
        return;
    }

    $description = "";
    $keywords = "";

    $metasArray = $parser->getMetatags();

    foreach($metasArray as $meta) {

        if($meta->getAttribute("name") == "description") {
            $description = $meta->getAttribute("content");
        }

        if($meta->getAttribute("name") == "keywords") {
            $keywords = $meta->getAttribute("content");
        }
    }

    $description = str_replace("\n", "", $description);
    $keywords = str_replace("\n", "", $keywords);


    if(linkExists($url)) {
        echo "$url already exists<br>";
    }
    else if(insertLink($url, $title, $description, $keywords)) {
        echo "SUCCESS: $url<br>";
    }
    else {
        echo "ERROR: Failed to insert $url<br>";
    }

    $imageArray = $parser->getImages();
    foreach($imageArray as $image) {
        $src = $image->getAttribute("src");
        $alt = $image->getAttribute("alt");
        $title = $image->getAttribute("title");

        if(!$title && !$alt) {
            continue;
        }

        $src = createLink($src, $url);

        if(!in_array($src, $alreadyFoundImages)) {
            $alreadyFoundImages[] = $src;

            insertImage($url, $src, $alt, $title);
        }

    }

    // Extraer detalles de videos
    $videoArray = $parser->getVideos();
    foreach($videoArray as $video) {
        $src = $video->getAttribute("src");
        $title = $video->getAttribute("title");
        
        // Detectar si es un video de YouTube
        if(strpos($src, "youtube.com/embed/") !== false) {
            $videoId = substr($src, strrpos($src, '/') + 1);
            $thumbnailUrl = "https://img.youtube.com/vi/$videoId/maxresdefault.jpg";
            insertVideo($src, $title, $thumbnailUrl);
        }
        // Detectar si es un video de Vimeo
        else if(strpos($src, "player.vimeo.com/video/") !== false) {
            $videoId = substr($src, strrpos($src, '/') + 1);
            $json = file_get_contents("https://vimeo.com/api/v2/video/$videoId.json");
            $data = json_decode($json);
            $thumbnailUrl = $data[0]->thumbnail_large;
            insertVideo($src, $title, $thumbnailUrl);
        }
    }
}

function followLinks($url) {

    global $alreadyCrawled;
    global $crawling;

    $parser = new DomDocumentParser($url);

    $linkList = $parser->getLinks();

    foreach($linkList as $link) {
        $href = $link->getAttribute("href");

        if(strpos($href, "#") !== false) {
            continue;
        }
        else if(substr($href, 0, 11) == "javascript:") {
            continue;
        }


        $href = createLink($href, $url);


        if(!in_array($href, $alreadyCrawled)) {
            $alreadyCrawled[] = $href;
            $crawling[] = $href;

            getDetails($href);
        }

    }

    array_shift($crawling);

    foreach($crawling as $site) {
        followLinks($site);
    }

}

// URL inicial para el crawling
$startUrl = "https://example.com";
followLinks($startUrl);
?>
