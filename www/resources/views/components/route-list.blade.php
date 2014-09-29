<div class="row route-list">
    <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1 col-xs-12">
        <div class="row">
            <div class="col-xs-12 route-list-header">
                {{{ $routeListHeader }}}
            </div>
            @if($routes->count() == 0)
                <div class="col-sm-8 col-sm-offset-2 col-xs-12" style="text-align: center;">
                    <span class="badge">Gösterilecek rota yok.</span>
                </div>
            @else
                @foreach($routes as $route)
                    <div class="col-sm-8 col-sm-offset-2 col-xs-12">
                        @include('components.route-list.route', ['route' => $route])
                    </div>
                @endforeach
            @endif
        </div>
    </div>
</div>