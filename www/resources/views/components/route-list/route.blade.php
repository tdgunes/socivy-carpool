<div class="row route">
    <div class="col-xs-10 col-xs-offset-1">
        <div class="row route-content">
            <div class="col-xs-12 header">
                <div class="row">
                    <div class="col-xs-8">
                        <i class="fa fa-clock-o"></i> {{{ Carbon\Carbon::now()->diffInHours($route->action_time) }}} saat sonra
                    </div>

                    <div class="col-xs-4" style="text-align: right;">
                        <i class="fa fa-child"></i> {{{ $route->seats }}}
                    </div>
                </div>
            </div>
            <div class="col-xs-12 content">
                <div class="row">

                    <div class="col-xs-12 plan">
                        @if($route->plan == "fromSchool")
                           <i class="fa fa-university"></i>
                           <i class="fa fa-long-arrow-right"></i>
                           <i class="fa fa-flag"></i>
                        @else
                            <i class="fa fa-flag"></i>
                            <i class="fa fa-long-arrow-right"></i>
                            <i class="fa fa-university"></i>
                        @endif
                    </div>

                    <div class="row">
                        <div class="col-xs-12 places">
                            @foreach($route->places as $place)
                               <div class="col-xs-12">
                                   <i class="fa fa-circle-o"></i> {{{ $place->name }}}
                               </div>
                            @endforeach
                        </div>
                    </div>
                    <div class="col-xs-6 user">
                        <i class="fa fa-car"></i> {{{ $route->user->name }}}
                    </div>
                    <div class="col-xs-6 action-time">
                        {{{ $route->action_time->format('m.d h:m') }}} <i class="fa fa-calendar"></i>
                    </div>
                </div>
            </div>
            <!--
            <div class="col-xs-12 footer">
                <a class="route-link btn btn-info" href="{{{ route('route.show', [$route->id]) }}}">Gör</a>
            </div>
            -->
        </div>
    </div>
</div>