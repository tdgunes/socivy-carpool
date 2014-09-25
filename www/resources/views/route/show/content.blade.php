<script>
    // DB'de ne varsa koy abi, kus buraya!
    var points = [];

    @foreach($route->places as $place)
        points.push({
            lng: {{{$place->longitude}}},
            lat: {{{$place->latitude}}},
            name: '{{{$place->name}}}'
        });
    @endforeach
</script>

<div class="row">
    <div class="col-md-12 col-xs-12 map-area">
        <div id="map">

        </div>
    </div>

    <div class="col-md-6 col-md-offset-3 col-xs-12 form-area">
        <div class="form-horizontal">
        <div class="row">

                @if(\Sentry::getUser()->id == $route->user_id)
                    <form action="{{{ route('route.destroy', [$route->id]) }}}" method="POST">
                        <input type="hidden" name="_method" value="DELETE">
                        <div class="btn-group btn-group-justified" style="margin-bottom: 30px;">
                            <div class="btn-group">
                                <button type="submit" class="btn btn-danger">Rotayı Sil</button>
                            </div>
                        </div>
                    </form>
                @endif

                @if($route->canRequest)
                    <div class="btn-group btn-group-justified" style="margin-bottom: 30px;">
                        <div class="btn-group">
                            <a href="{{{ route('route.request', [$route->id]) }}}" class="btn btn-success">Birlikte Git</a>
                        </div>
                    </div>
                @endif

                @if($route->canCancel)
                    <div class="btn-group btn-group-justified" style="margin-bottom: 30px;">
                        <div class="btn-group">
                            <a href="{{{ route('route.cancel', [$route->id]) }}}" class="btn btn-danger">İptal Et</a>
                        </div>
                    </div>
                @endif

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Yön</label>
                    <div class="col-xs-10">
                        @Lang('route.plan.' . $route->plan)
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-xs-2 control-label">Zaman</label>
                    <div class="col-xs-10">
                        <p>{{{ $route->action_time  }}}</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-xs-2 control-label">Kalan Koltuk Sayısı</label>
                    <div class="col-xs-10">
                        <p>{{{ $route->seats }}}</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-xs-2 control-label">İlan Sahibi</label>
                    <div class="col-xs-10">
                        <p>{{{ $route->user->name  }}}</p>
                        <p>{{{ $route->user->information->phone  }}}</p>
                        <p>{{{ $route->user->email  }}}</p>
                    </div>
                </div>

                @if($route->description)
                    <div class="form-group">
                        <label for="input-description" class="col-xs-2 control-label">Ek Bilgi</label>
                        <div class="col-xs-10">
                            <p>{{{ $route->description  }}}</p>
                        </div>
                    </div>
                @endif

                @if(\Sentry::getUser()->id == $route->user_id)
                    @foreach($route->companions as $companion)

                        <div class="form-group">
                            <label for="" class="col-xs-2 control-label">Gelecek Kişi</label>
                            <div class="col-xs-10">
                                <p>{{{ $companion->name  }}}</p>
                                <p>{{{ $companion->email  }}}</p>
                                <p>{{{ $companion->information->phone  }}}</p>
                            </div>
                        </div>

                    @endforeach
                @endif

        </div>
        </div>
    </div>
</div>