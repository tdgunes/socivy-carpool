@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/place/index.less" />
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('place.index.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop