<div class="row">
    <div class="col-xs-10 col-xs-offset-1 col-md-4 col-md-offset-4">
        <div class="row">
            <div class="col-xs-12">
                <h2 class="text-center">Mesajlar</h2>

                <div class="row">
                    @if($rooms->count() == 0)
                        <div class="col-xs-12 text-center">
                            <p class="badge">Mesaj Gönderebileceğiniz Birisi Yok</p>
                        </div>
                    @endif

                    <div class="col-xs-12">
                        <div class="list-group" style="margin-top: 35px">
                            @foreach($rooms as $room)
                                <a class="list-group-item" href="{{{ route('route.message-room.show', [$room->route->id, $room->id]) }}}">
                                    <span class="badge">{{{ $room->messages()->count() }}}</span>
                                    {{{ $room->creator->name }}}
                                </a>
                            @endforeach
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>