@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/route/create.less" />
    <link rel="stylesheet" href="/style/leaflet.css" />
    <link rel="stylesheet" href="/style/leaflet.awesome-markers.css" />
@stop

@section('scripts')
    @parent

    <script src="/js/leaflet.js"></script>
    <script src="/js/leaflet.awesome-markers.min.js"></script>
    <script src="/js/site/map.js"></script>
    <script src="/js/site/route/create.js"></script>
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('route.create.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop