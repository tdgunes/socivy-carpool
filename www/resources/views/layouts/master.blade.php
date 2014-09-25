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

        @if (Config::get('app.debug'))
            @section('head-debug')
                <!-- Less development mode for block local storage -->
                <script>
                    var less = {
                        env: 'development'
                    };
                </script>
            @show
        @endif

        @section('scripts')
            <script src="/js/jquery.min.js"></script>
            <script src="/js/bootstrap.min.js"></script>
            <script src="/js/less.min.js"></script>
        @show

        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

            ga('create', 'UA-55177652-2', 'auto');
            ga('send', 'pageview');
        </script>

        @yield('head-end')
    </head>
    <body>
        @yield('body')
    </body>
</html>