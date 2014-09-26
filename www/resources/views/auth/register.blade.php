@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/auth/register.less" />
@stop

@section('auth-form-content')
    <div class="col-xs-12 password-area">
        <input type="text" name="name" placeholder="İsim Soyad"/>
    </div>

    <div class="col-xs-12 email-area">
        <input type="text" name="email" placeholder="name@ozu.edu.tr"/>
    </div>

    <div class="col-xs-12 password-area">
        <input type="password" name="password" placeholder="password"/>
    </div>

    <div class="col-xs-12 email-area">
        <input type="text" name="phone" placeholder="5-- --- -- --"/>
    </div>

    <div class="col-xs-12 submit-area">
        <button type="submit" class="btn btn-info pull-right">Kaydol</button>
    </div>
@stop


@section('page-content')
    @include('auth.register.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop