<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function (Request $request) {
    return response()->json([
        "status" => true,
        "message" => "Cool API v1"
    ]);
});