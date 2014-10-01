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

<div class="row map-row">
    <div class="col-lg-9 col-xs-12 map-area">
        <div id="map">

        </div>

        <div class="point-popup" style="display: none;">
            <div class="row">
                <div class="col-xs-9">
                    <input class="point-name form-control" type="text"/>
                </div>
                <div class="col-xs-3">
                    <button type="submit" class="btn btn-danger delete-popup">Sil</button>
                </div>
            </div>
        </div>
    </div>


    <div class="col-lg-3 col-lg-offset-0 col-xs-10 col-xs-offset-1 form-area map-addition">

        <blockquote id="map-point-error" class="text-danger" style="padding-bottom: 10px; display: none;">Lütfen haritaya nokta ekleyiniz!</blockquote>

        @foreach ($errors->all() as $error)
        	<p class="bg-danger" style="padding: 10px;">{{{ $error }}}</p>
        @endforeach


        <div class="form-horizontal">

            @if(\Sentry::getUser()->id == $route->user_id)
                <form action="{{{ route('route.destroy', [$route->id]) }}}" method="POST">
                    <input type="hidden" name="_method" value="DELETE">
                    <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                        <div class="btn-group">
                            <button type="submit" class="btn btn-danger">Rotayı Sil</button>
                        </div>
                    </div>
                </form>
            @endif

            @if($route->canRequest)
                <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                    <div class="btn-group">
                        <a href="{{{ route('route.request', [$route->id]) }}}" class="btn btn-success">Birlikte Git</a>
                    </div>
                </div>
            @endif

            @if($route->canCreateMessageRoom)
                <form action="{{{ route('route.message-room.store', [$route->id]) }}}" method="post">
                    <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                        <div class="btn-group">
                            <button type="submit" class="btn btn-info">Mesaj Gönder</button>
                        </div>
                    </div>
                </form>
            @endif

            @if($route->messageRooms()->where('creator_id', Sentry::getUser()->id)->first())
                <form action="{{{ route('route.message-room.show', [$route->id]) }}}" method="post">
                    <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                        <div class="btn-group">
                            <button type="submit" class="btn btn-info">Mesaj Gönder</button>
                        </div>
                    </div>
                </form>
            @endif

            @if($route->isOwner)
                <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                    <div class="btn-group">
                        <a href="{{{ route('route.message-room.index', [$route->id]) }}}" class="btn btn-success">Gelen Mesajlar</a>
                    </div>
                </div>
            @endif

            @if($route->canCancel)
                <div class="btn-group btn-group-justified" style="margin-bottom: 20px;">
                    <div class="btn-group">
                        <a href="{{{ route('route.cancel', [$route->id]) }}}" class="btn btn-danger">İptal Et</a>
                    </div>
                </div>
            @endif

            <div class="form-group">
                <label for="input-description" class="col-xs-3 control-label">Yön</label>
                <div class="col-xs-9">
                    @Lang('route.plan.' . $route->plan)
                </div>
            </div>

            <div class="form-group">
                <label for="" class="col-xs-3 control-label">Zaman</label>
                <div class="col-xs-9">
                    <p>{{{ $route->action_time  }}}</p>
                </div>
            </div>

            <div class="form-group">
                <label for="" class="col-xs-3 control-label">Kalan Koltuk</label>
                <div class="col-xs-9">
                    <p>{{{ $route->seats }}}</p>
                </div>
            </div>

            <div class="form-group">
                <label for="" class="col-xs-3 control-label">İlan Sahibi</label>
                <div class="col-xs-9">
                    <p>{{{ $route->user->name }}}</p>
                    @if($route->user->routeSettings->show_phone)
                        <p>{{{ $route->user->information->phone }}}</p>
                    @endif
                    <p>{{{ $route->user->email  }}}</p>
                </div>
            </div>

            @if($route->description)
                <div class="form-group">
                    <label for="input-description" class="col-xs-3 control-label">Ek Bilgi</label>
                    <div class="col-xs-9">
                        <p>{{{ $route->description  }}}</p>
                    </div>
                </div>
            @endif

            @if($route->isOwner)
                @foreach($route->companions as $companion)
                    <div class="form-group">
                        <label for="" class="col-xs-3 control-label">Gelecek Kişi</label>
                        <div class="col-xs-9">
                            <p>{{{ $companion->name }}}</p>
                            <p>{{{ $companion->email }}}</p>
                            @if($companion->routeSettings->show_phone)
                                <p>{{{ $companion->information->phone }}}</p>
                            @endif
                        </div>
                    </div>
                @endforeach
            @endif

        </div>
    </div>
</div>