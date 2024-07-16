<?php
  
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
  
use App\Http\Controllers\api\RegisterController;
use App\Http\Controllers\api\ProductController;

Route::get('/', function (Request $request) {
    return response()->json([
        "status" => true,
        "message" => "Cool API v1"
    ]);
});
   
Route::controller(RegisterController::class)->group(function(){
    Route::post('register', 'register');
    Route::post('login', 'login');
});
         
Route::middleware('auth:sanctum')->group( function () {
    Route::resource('products', ProductController::class);
});