<div class="row">
    <div class="col-md-6 col-md-offset-3 col-xs-10 col-xs-offset-1 form-horizontal route-list">
        @foreach($routes as $route)
            <div class="row route">
                <div class="col-xs-12">
                    <div class="form-group">
                        <label for="" class="control-label col-xs-2">Plan Tipi</label>
                        <div class="col-xs-10">
                            <p>@Lang('route.plan.' . $route->plan)</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="" class="control-label col-xs-2">Geçtiği Noktalar</label>
                        <div class="col-xs-10">
                            <p>
                                @foreach($route->places as $place)
                                    {{{ $place->name }}}
                                @endforeach
                            </p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="" class="control-label col-xs-2">Hareket Saati</label>
                        <div class="col-xs-10">
                            <p>{{{ $route->action_time }}}</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="" class="control-label col-xs-2">Kalan Koltuk</label>
                        <div class="col-xs-10">
                            <p>{{{ $route->seats  }}}</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-xs-10 col-xs-offset-2">
                            <a href="{{{ route('route.show', [$route->id]) }}}" type="submit" class="btn btn-primary">Gör</a>
                        </div>
                    </div>

                </div>
            </div>
        @endforeach
    </div>
</div>