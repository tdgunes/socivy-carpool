<div class="row route">
    <div class="col-xs-10 col-xs-offset-1">
        <div class="row route-content">
            <div class="col-xs-12 header">
                <div class="row">
                    <?php
                        $today = Carbon\Carbon::today();

                        $dateClause = "";

                        if($today->diffInDays($route->action_time) == 1)
                        {
                            $dateClause = "Yarın ";
                        }
                        $dateClause .= $route->action_time->format('H:i');
                    ?>
                    <div class="col-xs-7">
                        <i class="fa fa-clock-o"></i> {{{ Carbon\Carbon::now()->diffInHours($route->action_time) }}} saat kaldı
                    </div>
                    <div class="col-xs-5 action-time" style="text-align: right;">
                        {{{ $dateClause }}}
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
                                   <i class="fa fa-flag"></i> {{{ $place->name }}}
                               </div>
                            @endforeach
                        </div>
                    </div>
                    <div class="col-xs-6 user">
                        <i class="fa fa-car"></i> {{{ $route->user->name }}}
                    </div>
                    <div class="col-xs-6" style="text-align: right;">
                        {{{ $route->seats }}} <i class="fa fa-child"></i>
                    </div>
                </div>
            </div>

            <a href="{{{ route('route.show', [$route->id]) }}}">
                <div class="col-xs-12 route-link">
                    Gör
                </div>
            </a>
        </div>
    </div>
</div>