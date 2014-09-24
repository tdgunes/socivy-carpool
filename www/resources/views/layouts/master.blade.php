<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>

        <title>
            @Lang('site.title')
        </title>

        @section('head-meta')
            <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        @show

        @section('styles')
            <link rel="stylesheet" href="/style/bootstrap.min.css" />
        @show

        @section('scripts')
            <script src="/js/jquery.min.js"></script>
            <script src="/js/bootstrap.min.js"></script>
            <script src="/js/less.min.js"></script>
        @show

        @yield('head-end')
    </head>
    <body>
        @yield('body')
    </body>
</html>