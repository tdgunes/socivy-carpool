@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/route/show.less" />
    <link rel="stylesheet" href="/style/leaflet.css" />
    <link rel="stylesheet" href="/style/leaflet.awesome-markers.css" />
@stop

@section('scripts')
    @parent

    <script src="/js/site/user/show.js"></script>
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('user.show.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop