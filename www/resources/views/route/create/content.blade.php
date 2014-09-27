<script>
    // DB'de ne varsa koy abi, kus buraya!
    var points = [];

    @foreach(App\Place::all() as $place)
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
                    <p class="col-xs-9 point-name"></p>
                    <button class="col-xs-3 btn btn-info add-to-route">Ekle</button>
                    <button class="col-xs-3 btn btn-danger remove-from-route" style="display: none;">Sil</button>
            </div>
        </div>
    </div>


    <div class="col-lg-3 col-lg-offset-0 col-xs-10 col-xs-offset-1 form-area map-addition">

        <blockquote id="map-point-error" class="text-danger" style="padding-bottom: 10px; display: none;">Lütfen haritaya nokta ekleyiniz!</blockquote>

        @foreach ($errors->all() as $error)
        	<p class="bg-danger" style="padding: 10px;">{{{ $error }}}</p>
        @endforeach


        <form id="route-form" action="{{{ route('route.store')  }}}" method="post" class="form-horizontal" role="form">

            <div class="form-group">
                <label for="input-description" class="col-xs-3 control-label">Plan</label>
                <div class="col-xs-9">
                    <div class="radio">
                        <label for="plan-from-school">
                            <input id="plan-from-school" required name="plan" value="fromSchool" type="radio"/> ÖzÜ'den Durağa
                        </label>
                    </div>

                    <div class="radio">
                        <label for="plan-to-school">
                            <input id="plan-to-school" required name="plan" value="toSchool" type="radio"/> Duraktan ÖzÜ'ye
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="" class="col-xs-3 control-label">Yola Çıkış Günü</label>
                <div class="col-xs-9">
                    <div class="row">
                        <div class="col-lg-12 col-sm-3 col-xs-12">
                            <select name="action_day" class="form-control">
                                <option value="0">Bugün</option>
                                <option value="1">Yarın</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="" class="col-xs-3 control-label">Yola Çıkış Saati</label>
                <div class="col-xs-9">
                    <div class="row">
                        <div class="col-xs-6 col-sm-3 col-lg-5">
                            <select name="action_hour" class="form-control">
                                @for($i=0; $i<10; $i++)
                                    <option value="{{{0 . $i}}}">{{{0 . $i}}}</option>
                                @endfor
                                @for($i=10; $i<24; $i++)
                                    <option value="{{{$i}}}">{{{$i}}}</option>
                                @endfor
                            </select>
                        </div>
                        <div class="col-xs-6 col-sm-3 col-lg-5">
                            <select name="action_minute" class="form-control">
                                <option value="00">00</option>
                                <option value="00">05</option>
                                @for($i=10; $i<60; $i=$i+5)
                                    <option value="{{{$i}}}">{{{$i}}}</option>
                                @endfor
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="input-description" class="col-xs-3 control-label">Boş koltuk</label>
                <div class="col-xs-4 col-sm-3">
                    <input required type="number" min="1" max="50" name="available_seat" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label for="input-description" class="col-xs-3 control-label">Ek Bilgi</label>
                <div class="col-xs-9">
                    <textarea style="width: 100%;" name="description" cols="30" rows="3" class="form-control"></textarea>
                </div>
            </div>

            <div class="btn-group btn-group-justified">
                <div class="btn-group">
                    <button type="submit" class="btn btn-success">Paylaş!</button>
                </div>
            </div>

        </form>
    </div>
</div>