<div class="row route-list">
    <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1 col-xs-12">
        <div class="row">
            @for($i=0; $i<$columnCount; $i++)
                <div class="col-md-4 col-sm-6 col-xs-12">
                    @for($i2=$i; $i2<$routes->count(); $i2=$i2+$columnCount)
                    <?php $route = $routes[$i2] ?>
                        @include('components.route-list.route', ['route' => $route])
                    @endfor
                </div>
            @endfor
        </div>
    </div>

    <div class="col-md-3 col-xs-10">
        @foreach($routes as $route)

        @endforeach
    </div>
</div>