<div class="row">
    <div class="col-md-6 col-md-offset-3 col-xs-10 col-xs-offset-1">

        <div class="row">
            <div class="col-xs-12">
                @foreach ($errors->all() as $error)
                    <p class="bg-danger" style="padding: 10px;">{{{ $error }}}</p>
                @endforeach
            </div>
        </div>

        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">
                    Mesajlar
                </h1>
            </div>

            <div class="row">
                <div class="col-xs-12">
                    @foreach($room->messages as $message)
                        <div class="row">
                            <div class="col-xs-12">
                                @if($message->user_id == Sentry::getUser()->id)
                                    <blockquote class="blockquote-reverse">
                                @else
                                    <blockquote class="blockquote">
                                @endif
                                        {{{ $message->message }}}
                                        <footer>{{{ $message->created_at->toDateTimeString() }}}</footer>
                                    </blockquote>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>

            <form class="form-horizontal" action="{{{ route('route.message-room.message.store', [$room->route_id, $room->id]) }}}" method="post">
                <div class="row">
                    <div class="col-xs-12">
                        <textarea name="message" id="" cols="30" rows="3" class="form-control"></textarea>
                    </div>

                    <div class="col-xs-12">
                        <div class="btn-group btn-group-justified" style="margin-top: 30px;">
                            <div class="btn-group">
                                <button type="submit" class="btn btn-info">Gönder</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>