@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/auth/login.less" />
@stop

@section('auth-form-content')
    <div class="col-xs-12 email-area">
        <input type="email" name="email" placeholder="name@ozu.edu.tr"/>
    </div>

    <div class="col-xs-12 password-area">
        <input type="password" name="password" placeholder="password"/>
    </div>

    <div class="col-xs-12 submit-area">
        <button type="submit" class="btn btn-info pull-right">Giriş</button>
    </div>
@stop

@section('page-content')
    @include('auth.login.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop