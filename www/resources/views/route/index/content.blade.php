<div class="row">
    <div class="col-md-6 col-md-offset-3 col-xs-12 form-horizontal route-list">
        @foreach($routes as $route)
            <div class="row route">
                <div class="col-xs-12">
                    <div class="form-control">
                        <label for="" class="control-label col-xs-2">Plan Tipi</label>
                        <div class="col-xs-10">
                            <p>@Lang('route.plan.' . $route->plan)</p>
                        </div>
                    </div>

                    <div class="form-control">
                        <label for="" class="control-label col-xs-2">Geçtiği Noktalar</label>
                        <div class="col-xs-10">
                            <p>
                                @foreach($route->places as $place)
                                    {{{ $place->name }}}
                                @endforeach
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
</div>