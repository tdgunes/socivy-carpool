@extends('layouts.master')

@section('styles')
    @parent

    <link rel="stylesheet/less" href="/style/site/route/message-room/index.less" />
@stop

@section('page-content')

    @include('layouts.body.page.metabar')

    @include('route.message-room.index.content')

    @include('layouts.body.page.footer')
@stop

@section('body')
    @include('layouts.body.page')
@stop