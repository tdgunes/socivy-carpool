@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/place/create.less" />
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('place.create.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop