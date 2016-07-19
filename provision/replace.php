<?php

function getDirContents($dir, $results = array()){
    $files = scandir($dir);

    foreach($files as $key => $value){
        $path = realpath($dir.DIRECTORY_SEPARATOR.$value);
        if(!is_dir($path) && !strstr($path,  '.php')) {
            $results[] = $path;
        } else if(is_dir($path) && $value != "." && $value != "..") {
            $results = getDirContents($path, $results);
        }
    }

    return $results;
}

$placeholders = require_once __DIR__ . '/placeholders.php';

foreach (getDirContents(__DIR__) as $fileName) {
    $fileContent = file_get_contents($fileName);

    $fileContent = str_replace(array_keys($placeholders), array_values($placeholders), $fileContent);

    $replaceInFileName = [
        'conf.d.templates' => 'conf.d',
        'm2-reinstall.template' => 'm2-reinstall.sh',
    ];
    $newFileName = str_replace(array_keys($replaceInFileName), array_values($replaceInFileName), $fileName);

    file_put_contents($newFileName, $fileContent);
}


