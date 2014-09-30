@extends('...layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/me/settings.less" />
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('me.settings.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop