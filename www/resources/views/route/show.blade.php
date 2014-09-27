@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/route/show.less" />
    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
    <link rel="stylesheet" href="/style/leaflet.awesome-markers.css" />
@stop

@section('scripts')
    @parent

    <script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
    <script src="/js/leaflet.awesome-markers.min.js"></script>
    <script src="/js/site/map.js"></script>
    <script src="/js/site/route/show.js"></script>
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('route.show.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop