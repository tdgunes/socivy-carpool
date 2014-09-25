<div class="row">
    <div class="col-md-12 col-xs-12 map-area">
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


    <div class="col-md-6 col-md-offset-3 col-xs-12 form-area">

        <blockquote class="text-success" style="padding-bottom: 10px;">Haritaya çift tıklayarak uğrayacağınız noktaları ekleyebilirsiniz. Noktaların üzerine genel bir ad ekleyiniz.</blockquote>
        <blockquote id="map-point-error" class="text-danger" style="padding-bottom: 10px; display: none;">Lütfen haritaya nokta ekleyiniz!</blockquote>

        @foreach ($errors->all() as $error)
        	<p class="bg-danger" style="padding: 10px;">{{{ $error }}}</p>
        @endforeach

        <div class="row">

            <form id="route-form" action="{{{ route('route.store')  }}}" method="post" class="form-horizontal" role="form">

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Plan</label>
                    <div class="col-xs-10">
                        <div class="radio-inline">
                            <label for="plan-from-school">
                                <input id="plan-from-school" required name="plan" value="fromSchool" type="radio"/> ÖzÜ'den Durağa
                            </label>
                        </div>

                        <div class="radio-inline">
                            <label for="plan-to-school">
                                <input id="plan-to-school" required name="plan" value="toSchool" type="radio"/> Duraktan ÖzÜ'ye
                            </label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-xs-2 control-label">Yola Çıkış Vakti</label>
                    <div class="col-xs-5">
                        <div class='input-group date' id='datetimepicker'>
                            <input readonly required name="date" type='text' class="form-control" data-date-format="YYYY/MM/DD hh:mm"/>
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                    </div>
                </div>

                <script type="text/javascript">
                    $(function () {
                        $('#datetimepicker').datetimepicker()
                            .data("DateTimePicker")
                            .setMinDate(new Date());
                    });
                </script>

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Boş koltuk</label>
                    <div class="col-xs-2">
                        <input required type="text" name="available_seat" id="description" class="form-control">
                    </div>
                </div>

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Ek Bilgi</label>
                    <div class="col-xs-10">
                        <textarea id="description" name="description" cols="30" rows="3" class="form-control"></textarea>
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
</div>